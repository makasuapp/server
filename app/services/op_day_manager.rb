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
    #TODO(po_time): use the times from predicted orders
    preps = self.create_day_preps(predicted_orders, op_day, made_qtys)
    self.create_day_ingredients(predicted_orders, op_day, ingredient_qtys, preps)
  end

  sig {params(op_day: OpDay).returns(T::Hash[Integer, StepAmount])}
  def self.prep_made_qtys(op_day)
    op_day.day_preps.inject({}) do |prep_map, prep|
      if prep_map[prep.recipe_step_id].nil?
        if prep.made_qty.present?
          prep_map[prep.recipe_step_id] = StepAmount.mk(prep.recipe_step_id, T.must(prep.made_qty))
        end
      else
        raise "unexpected, more than one day prep with same recipe step id"
      end

      prep_map
    end
  end

  sig {params(op_day: OpDay).returns(T::Hash[Integer, T::Array[IngredientAmount]])}
  def self.ingredient_had_qtys(op_day)
    op_day.day_ingredients.inject({}) do |ingredient_map, ingredient|
      if ingredient.had_qty.present?
        if ingredient_map[ingredient.ingredient_id].nil?
          ingredient_map[ingredient.ingredient_id] = []
        end

        ingredient_map[ingredient.ingredient_id] << Ingredient.mk(
          ingredient.ingredient_id, T.must(ingredient.had_qty), ingredient.unit)
      end

      ingredient_map
    end
  end

  # aggregate the amount of prep for each step for the day
  sig {params(predicted_orders: PredictedOrder::ActiveRecord_Relation, op_day: OpDay, 
    prep_made_qtys: T::Hash[Integer, StepAmount]).returns(T::Array[DayPrep])} 
  def self.create_day_preps(predicted_orders, op_day, prep_made_qtys)
    day_preps = {}

    predicted_orders.includes({recipe: {recipe_steps: :inputs}}).each do |pr|
      recipe = pr.recipe
      recipe_servings = recipe.servings_produced(pr.quantity)

      #get step amounts of prep steps of the recipe
      prep_step_amounts = recipe.recipe_steps
        .select { |step| step.step_type == StepType::Prep }
        .map { |step| StepAmount.mk(step.id, 1) }
      
      #get step amounts of all steps of subrecipes
      subrecipe_step_amounts = recipe.recipe_steps.map { |step| 
        step.inputs.select { |input| 
          input.inputable_type == InputType::Recipe
        }.map { |recipe_input|
          child_recipe = recipe_input.inputable
          child_steps = child_recipe.step_amounts

          num_servings = child_recipe.servings_produced(recipe_input.quantity, recipe_input.unit)
          child_step_amounts = child_steps.map { |x| x * num_servings }
        }
      }.flatten

      #aggregate into day preps
      (prep_step_amounts + subrecipe_step_amounts).each do |step_amount|
        recipe_step_id = step_amount.recipe_step_id
        existing_prep = day_preps[recipe_step_id]
        additional_qty = step_amount.quantity * recipe_servings

        if existing_prep.nil?
          made_step_amount = prep_made_qtys[step_amount.recipe_step_id]
          day_preps[recipe_step_id] = DayPrep.new(
            expected_qty: additional_qty,
            op_day_id: op_day.id,
            recipe_step_id: recipe_step_id,
            made_qty: made_step_amount.try(:quantity)
          )
        else
          existing_prep.expected_qty = existing_prep.expected_qty + additional_qty
          day_preps[recipe_step_id] = existing_prep
        end
      end
    end

    DayPrep.import! day_preps.values

    day_preps.values
  end

  # aggregate the amount of ingredients needed for the day
  # note: may have different non-convertable units of the same ingredient
  sig {params(predicted_orders: PredictedOrder::ActiveRecord_Relation, op_day: OpDay, 
    ingredient_had_qtys: T::Hash[Integer, T::Array[IngredientAmount]], preps: T::Array[DayPrep]
    ).returns(T::Array[DayIngredient])} 
  def self.create_day_ingredients(predicted_orders, op_day, ingredient_had_qtys, preps = [])
    ingredient_amounts = predicted_orders.map(&:ingredient_amounts).flatten
    #TODO(po_time): multiple ingredient qty by multiplier of prep
    # when we add timing, add equivalent timing to relevant ingredients here
    # or when do ingredient amounts, also do prep timing?
    # preps.each do |prep|
    #   ingredient_amounts = ingredient_amounts + step.inputs.select { |input| 
    #     input.inputable_type == InputType::Ingredient
    #   }.map { |input| 
    #     IngredientAmount.mk(input.inputable_id, input.quantity, input.unit)
    #   }
    # end
    aggregated_amounts = IngredientAmount.sum_by_id(ingredient_amounts)

    day_ingredients = aggregated_amounts.map do |a|
      ingredient = Ingredient.find(a.ingredient_id)
      had_qty_amounts = ingredient_had_qtys[a.ingredient_id]
      if had_qty_amounts.present?
        matches_unit_amount = had_qty_amounts.find { |i| 
          UnitConverter.can_convert?(i.unit, a.unit, ingredient.volume_weight_ratio) }
        if matches_unit_amount.present?
          had_qty = UnitConverter.convert(matches_unit_amount.quantity, matches_unit_amount.unit,
            a.unit, ingredient.volume_weight_ratio)
        end
      end

      DayIngredient.new(
        ingredient_id: a.ingredient_id,
        expected_qty: a.quantity,
        unit: a.unit,
        op_day_id: op_day.id,
        had_qty: had_qty
      )
    end
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