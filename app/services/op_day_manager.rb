# typed: strict

class OpDayManager
  extend T::Sig

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), kitchen: Kitchen).void}
  def self.update_day_for(date, kitchen)
    op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)

    made_qtys = self.prep_made_qtys(op_day)
    ingredient_qtys = self.ingredient_had_qtys(op_day)

    #clear existing
    op_day.day_ingredients.delete_all
    op_day.day_preps.delete_all

    #regenerate for all recipes of that date 
    predicted_orders = PredictedOrder.where(date: date, kitchen_id: kitchen.id)
    preps = self.create_day_preps(predicted_orders, op_day, made_qtys)
    self.create_day_ingredients(predicted_orders, op_day, ingredient_qtys, preps)
  end

  #assumes prev day preps already properly aggregated
  sig {params(op_day: OpDay).returns(T::Hash[Integer, T::Array[StepAmount]])}
  def self.prep_made_qtys(op_day)
    op_day.day_preps.inject({}) do |prep_map, prep|
      if prep.made_qty.present?
        if prep_map[prep.recipe_step_id].nil?
          prep_map[prep.recipe_step_id] = []
        end

        prep_map[prep.recipe_step_id] << StepAmount.mk(prep.recipe_step_id, prep.min_needed_at, prep.made_qty)
      end

      prep_map
    end
  end

  #assumes prev day ingredients already properly aggregated
  sig {params(op_day: OpDay).returns(T::Hash[Integer, T::Array[IngredientAmount]])}
  def self.ingredient_had_qtys(op_day)
    op_day.day_ingredients.inject({}) do |ingredient_map, ingredient|
      if ingredient.had_qty.present?
        if ingredient_map[ingredient.ingredient_id].nil?
          ingredient_map[ingredient.ingredient_id] = []
        end

        ingredient_map[ingredient.ingredient_id] << IngredientAmount.mk(
          ingredient.ingredient_id, ingredient.min_needed_at, ingredient.had_qty, ingredient.unit)
      end

      ingredient_map
    end
  end

  # aggregate the amount of prep for each step for the day
  # note: may have same prep needed at diff times of day
  sig {params(predicted_orders: PredictedOrder::ActiveRecord_Relation, op_day: OpDay, 
    prep_made_qtys: T::Hash[Integer, T::Array[StepAmount]]).returns(T::Array[DayPrep])} 
  def self.create_day_preps(predicted_orders, op_day, prep_made_qtys)
    day_preps_map = {}
    predicted_orders.includes({recipe: {recipe_steps: :inputs}}).each do |po|
      recipe = po.recipe
      for_date = po.date
      recipe_servings = recipe.servings_produced(po.quantity)

      #get step amounts of prep steps of the recipe
      prep_step_amounts = recipe.recipe_steps
        .select { |step| step.step_type == StepType::Prep }
        .map { |step| StepAmount.mk(step.id, step.min_needed_at(for_date), 1) }
      
      #get step amounts of all steps of subrecipes
      subrecipe_step_amounts = recipe.recipe_steps.map { |step| 
        step.inputs.select { |input| 
          input.inputable_type == InputType::Recipe
        }.map { |recipe_input|
          step_needed_at = step.min_needed_at(for_date)
          child_recipe = recipe_input.inputable
          child_steps = child_recipe.step_amounts(step_needed_at)

          num_servings = child_recipe.servings_produced(recipe_input.quantity, recipe_input.unit)
          child_step_amounts = child_steps.map { |x| x * num_servings }
        }
      }.flatten

      #aggregate into day preps
      (prep_step_amounts + subrecipe_step_amounts).each do |step_amount|
        recipe_step_id = step_amount.recipe_step_id
        additional_qty = step_amount.quantity * recipe_servings

        if day_preps_map[recipe_step_id].nil?
          day_preps_map[recipe_step_id] = []
        end

        #add together ones from the same time
        matches_idx  = day_preps_map[recipe_step_id].find_index { |p| 
          p.min_needed_at.to_i == step_amount.min_needed_at.to_i }
        if matches_idx.nil?
          made_step_amounts = prep_made_qtys[step_amount.recipe_step_id]
          if made_step_amounts.present?
            made_step_amount = made_step_amounts.find { |s| 
              s.min_needed_at.to_i == step_amount.min_needed_at.to_i }
            if made_step_amount.present?
              made_qty = made_step_amount.quantity
            end
          end

          day_preps_map[recipe_step_id] << DayPrep.new(
            expected_qty: additional_qty,
            op_day_id: op_day.id,
            recipe_step_id: recipe_step_id,
            min_needed_at: step_amount.min_needed_at,
            made_qty: made_qty,
            kitchen_id: op_day.kitchen_id
          )
        else
          existing_prep = day_preps_map[recipe_step_id][matches_idx]
          existing_prep.expected_qty = existing_prep.expected_qty + additional_qty
          day_preps_map[recipe_step_id][matches_idx] = existing_prep
        end
      end
    end

    day_preps = day_preps_map.values.flatten
    DayPrep.import! day_preps

    day_preps
  end

  #TODO(po_time): frontend for prep checklist will need to sort by time and show rough timeline

  # aggregate the amount of ingredients needed for the day
  # for ingredients we want to aggregate all for the same day, even if different min_needed_at
  # note: may still have different non-convertable units of the same ingredient 
  sig {params(predicted_orders: PredictedOrder::ActiveRecord_Relation, op_day: OpDay, 
    ingredient_had_qtys: T::Hash[Integer, T::Array[IngredientAmount]], preps: T::Array[DayPrep]
    ).returns(T::Array[DayIngredient])} 
  def self.create_day_ingredients(predicted_orders, op_day, ingredient_had_qtys, preps = [])
    #get all ingredients needed across all orders
    ingredient_amounts = predicted_orders.map(&:ingredient_amounts).flatten

    #aggregate into day ingredients
    day_ingredients_map = {}
    ingredient_amounts.each do |i_amount|
      ingredient_id = i_amount.ingredient_id
      #TODO(timezone)
      on_date = i_amount.min_needed_at.in_time_zone("America/Toronto").beginning_of_day

      if day_ingredients_map[ingredient_id].nil?
        day_ingredients_map[ingredient_id] = []
      end

      ingredient = Ingredient.find(ingredient_id)
      matches_idx  = day_ingredients_map[ingredient_id].find_index { |i| 
        i.min_needed_at.to_i == on_date.to_i &&
        UnitConverter.can_convert?(i.unit, i_amount.unit, ingredient.volume_weight_ratio) }
      if matches_idx.nil?
        had_qty_amounts = ingredient_had_qtys[i_amount.ingredient_id]
        if had_qty_amounts.present?
          matches_unit_amount = had_qty_amounts.find { |i| 
            UnitConverter.can_convert?(i.unit, i_amount.unit, ingredient.volume_weight_ratio) &&
            i.min_needed_at.to_i == on_date.to_i }
          if matches_unit_amount.present?
            had_qty = UnitConverter.convert(matches_unit_amount.quantity, matches_unit_amount.unit,
              i_amount.unit, ingredient.volume_weight_ratio)
          end
        end

        day_ingredients_map[ingredient_id] << DayIngredient.new(
          ingredient_id: ingredient_id,
          expected_qty: i_amount.quantity,
          unit: i_amount.unit,
          op_day_id: op_day.id,
          min_needed_at: on_date,
          had_qty: had_qty,
          kitchen_id: op_day.kitchen_id
        )
      else
        existing_ingredient = day_ingredients_map[ingredient_id][matches_idx]
        additional_qty = UnitConverter.convert(i_amount.quantity, i_amount.unit,
          existing_ingredient.unit, ingredient.volume_weight_ratio)
        existing_ingredient.expected_qty = existing_ingredient.expected_qty + additional_qty

        day_ingredients_map[ingredient_id][matches_idx] = existing_ingredient
      end
    end

    day_ingredients = day_ingredients_map.values.flatten
    DayIngredient.import! day_ingredients

    day_ingredients
  end

  sig {params(
    day_ingredients: T.any(
      DayIngredient::ActiveRecord_Relation, 
      DayIngredient::ActiveRecord_AssociationRelation,
      T::Array[DayIngredient]), 
    vendor: Vendor, date: T.any(DateTime, ActiveSupport::TimeWithZone),
    kitchen: Kitchen).void}
  def self.create_procurement(day_ingredients, vendor, date, kitchen)
    po = ProcurementOrder
    po = ProcurementOrder.create!(
      for_date: date, 
      order_type: "manual",
      kitchen_id: kitchen.id,
      vendor_id: vendor.id
    )
    day_ingredients.each do |di|
      po.procurement_items.create!(
        ingredient_id: di.ingredient_id, 
        quantity: di.expected_qty,
        unit: di.unit
      )
    end
  end
end