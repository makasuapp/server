# typed: strict

class OpDayManager
  extend T::Sig

  #TODO: would be better if we had an update mechanism that didn't involve deleting all 
  #TODO: maybe we should re-use ids?
  #re-generate the day's prep/inputs
  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), kitchen: Kitchen).void}
  def self.update_day_for(date, kitchen)
    op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)

    made_qtys = self.prep_made_qtys(op_day)
    input_qtys = self.input_had_qtys(op_day)

    #clear existing
    op_day.day_inputs.delete_all
    op_day.day_preps.delete_all

    #regenerate for all recipes of that date 
    predicted_orders = PredictedOrder.where(date: date, kitchen_id: kitchen.id)
    self.create_day(predicted_orders, op_day, input_qtys, made_qtys)
  end

  sig {params(input: T.any(InputAmount, DayInput)).returns(String)}
  def self.input_map_key(input)
    "#{input.inputable_type}#{input.inputable_id}"
  end

  #assumes prev day preps already properly aggregated
  sig {params(op_day: OpDay).returns(T::Hash[Integer, T::Hash[Integer, StepAmount]])}
  def self.prep_made_qtys(op_day)
    op_day.day_preps.inject({}) do |prep_map, prep|
      if prep.made_qty.present?
        if prep_map[prep.recipe_step_id].nil?
          prep_map[prep.recipe_step_id] = {}
        end

        prep_map[prep.recipe_step_id][prep.min_needed_at.to_i] = StepAmount.mk(
          prep.recipe_step_id, prep.min_needed_at, prep.made_qty)
      end

      prep_map
    end
  end

  #assumes prev day inputs already properly aggregated
  sig {params(op_day: OpDay).returns(T::Hash[String, T::Hash[Integer, T::Array[InputAmount]]])}
  def self.input_had_qtys(op_day)
    op_day.day_inputs.inject({}) do |input_map, input|
      map_key = self.input_map_key(input)
      day_needed_at_i = input.min_needed_at.to_i

      if input.had_qty.present?
        if input_map[map_key].nil?
          input_map[map_key] = {}
        end
        if input_map[map_key][day_needed_at_i].nil?
          input_map[map_key][day_needed_at_i] = []
        end

        input_map[map_key][day_needed_at_i] << InputAmount.mk(
          input.inputable_id, input.inputable_type, input.min_needed_at, 
          input.had_qty, input.unit)
      end

      input_map
    end
  end

  # aggregate the amount of inputs/prep for the day
  # for inputs we want to aggregate all for the same day, even if different min_needed_at
  # prep we want distinguished by what time of day we want them at
  sig {params(
    predicted_orders: PredictedOrder::ActiveRecord_Relation, 
    op_day: OpDay, 
    input_had_qtys: T::Hash[String, T::Hash[Integer, T::Array[InputAmount]]], 
    prep_made_qtys: T::Hash[Integer, T::Hash[Integer, StepAmount]]
    ).void} 
  def self.create_day(predicted_orders, op_day, input_had_qtys, prep_made_qtys)
    day_preps_map = {}
    day_inputs_map = {}

    predicted_orders.includes({recipe: {recipe_steps: :inputs}}).each do |po|
      recipe = po.recipe
      for_date = po.date
      recipe_servings = recipe.servings_produced(po.quantity)

      subrecipe_step_amounts, input_amounts = recipe.component_amounts(for_date)

      #aggregate into day preps
      subrecipe_step_amounts.each do |step_amount|
        recipe_step_id = step_amount.recipe_step_id
        additional_qty = step_amount.quantity * recipe_servings

        if day_preps_map[recipe_step_id].nil?
          day_preps_map[recipe_step_id] = {}
        end

        #add together ones from the same time
        min_needed_at_i = step_amount.min_needed_at.to_i
        existing_prep = day_preps_map[recipe_step_id][min_needed_at_i]
        if existing_prep.nil?
          made_step_amounts = prep_made_qtys[step_amount.recipe_step_id]
          if made_step_amounts.present?
            made_step_amount = made_step_amounts[min_needed_at_i]
            if made_step_amount.present?
              made_qty = made_step_amount.quantity
            end
          end

          day_preps_map[recipe_step_id][min_needed_at_i] = DayPrep.new(
            expected_qty: additional_qty,
            op_day_id: op_day.id,
            recipe_step_id: recipe_step_id,
            min_needed_at: step_amount.min_needed_at,
            made_qty: made_qty,
            kitchen_id: op_day.kitchen_id
          )
        else
          existing_prep.expected_qty = existing_prep.expected_qty + additional_qty
          day_preps_map[recipe_step_id][min_needed_at_i] = existing_prep
        end
      end

      #aggregate into day inputs
      input_amounts.each do |i_amount|
        map_key = self.input_map_key(i_amount)
        #TODO(timezone)
        day_needed_at = DayInput.day_needed_at(i_amount.min_needed_at
          .in_time_zone("America/Toronto"))
        day_needed_at_i = day_needed_at.to_i

        input_qty = i_amount.quantity * recipe_servings

        if day_inputs_map[map_key].nil?
          day_inputs_map[map_key] = {}
        end

        if day_inputs_map[map_key][day_needed_at_i].nil?
          day_inputs_map[map_key][day_needed_at_i] = []
        end

        input = i_amount.inputable
        match_idx = day_inputs_map[map_key][day_needed_at_i].find_index { |i| 
          UnitConverter.can_convert?(i.unit, i_amount.unit, input.volume_weight_ratio) }
        if match_idx.nil?
          had_qty_amounts = input_had_qtys[map_key] && T.must(input_had_qtys[map_key])[day_needed_at_i]
          if had_qty_amounts.present?
            matches_unit_amount = had_qty_amounts.find { |i| 
              UnitConverter.can_convert?(i.unit, i_amount.unit, input.volume_weight_ratio) }
            if matches_unit_amount.present?
              had_qty = UnitConverter.convert(matches_unit_amount.quantity, matches_unit_amount.unit,
                i_amount.unit, input.volume_weight_ratio)
            end
          end

          day_inputs_map[map_key][day_needed_at_i] << DayInput.new(
            inputable_id: i_amount.inputable_id,
            inputable_type: i_amount.inputable_type,
            expected_qty: input_qty,
            unit: i_amount.unit,
            op_day_id: op_day.id,
            min_needed_at: day_needed_at,
            had_qty: had_qty,
            kitchen_id: op_day.kitchen_id
          )
        else
          existing_input = day_inputs_map[map_key][day_needed_at_i][match_idx]
          additional_qty = UnitConverter.convert(input_qty, i_amount.unit,
            existing_input.unit, input.volume_weight_ratio)
          existing_input.expected_qty = existing_input.expected_qty + additional_qty

          day_inputs_map[map_key][day_needed_at_i][match_idx] = existing_input
        end
      end
    end

    #remove ingredients and preps based on recipe had_qty
    recipe_had_qtys = input_had_qtys.values.map(&:values).flatten.select { 
      |input| input.inputable_type == DayInputType::Recipe }
    recipe_had_qtys.each do |recipe_had_qty|
      #some may be generated by component_amounts, ignore that qty
      recipe_map_key = self.input_map_key(recipe_had_qty)
      day_needed_at_i = recipe_had_qty.min_needed_at.to_i
      added_recipe_qtys = day_inputs_map[recipe_map_key][day_needed_at_i]
      if added_recipe_qtys.present?
        #shouldn't be able to have a recipe that can't convert
        added_recipe_qty = added_recipe_qtys.first
        had_qty = added_recipe_qty.expected_qty - recipe_had_qty.quantity
      else
        had_qty = 0
      end
 
      if had_qty > 0
        had_recipe = Recipe.find(recipe_had_qty.inputable_id)
        #for_date is end of day since we want to check against any from the day
        for_date = recipe_had_qty.min_needed_at.end_of_day
        removing_step_amounts, removing_input_amounts = had_recipe.component_amounts(for_date, true)
 
        removing_step_amounts.each do |removing_step_amount|
          recipe_step_id = removing_step_amount.recipe_step_id
          #remove earliest needed of that step
          added_step = day_preps_map[recipe_step_id].first
          if added_step.present?
            added_step.expected_qty = added_step.expected_qty - removing_step_amount.quantity
            min_needed_at_i = added_step.min_needed_at.to_i
            if added_step.expected_qty > 0
              day_preps_map[recipe_step_id][min_needed_at_i] = added_step
            else
              day_preps_map[removing_step_amount.recipe_step_id][min_needed_at_i] = nil
            end
          end
        end
 
        removing_input_amounts.each do |removing_input_amount|
          map_key = self.input_map_key(removing_input_amount)
          #TODO(timezone)
          day_needed_at_i = DayInput.day_needed_at(
            removing_input_amount.min_needed_at.in_time_zone("America/Toronto")).to_i
          added_inputs = day_inputs_map[map_key][day_needed_at_i]
          input = removing_input_amount.inputable
          match_idx = day_inputs_map[map_key][day_needed_at_i].find_index { |i| 
            UnitConverter.can_convert?(removing_input_amount.unit, i.unit, 
              input.volume_weight_ratio) }
          if match_idx.present?
            added_input = day_inputs_map[map_key][day_needed_at_i][match_idx]
            added_input.expected_qty = added_input.expected_qty - 
              UnitConverter.convert(removing_input_amount.quantity, removing_input_amount.unit,
                added_input.unit, input.volume_weight_ratio)
            if added_input.expected_qty > 0
              day_inputs_map[map_key][day_needed_at_i][match_idx] = added_input
            else
              day_preps_map[map_key][day_needed_at_i][match_idx] = nil
            end
          end
        end
      end
    end
 
    DayInput.import! day_inputs_map.values.map(&:values).flatten
    DayPrep.import! day_preps_map.values.map(&:values).flatten
  end

  sig {params(
    day_inputs: T.any(
      DayInput::ActiveRecord_Relation, 
      DayInput::ActiveRecord_AssociationRelation,
      T::Array[DayInput]), 
    vendor: Vendor, date: T.any(DateTime, ActiveSupport::TimeWithZone),
    kitchen: Kitchen).void}
  def self.create_procurement(day_inputs, vendor, date, kitchen)
    po = ProcurementOrder
    po = ProcurementOrder.create!(
      for_date: date, 
      order_type: "manual",
      kitchen_id: kitchen.id,
      vendor_id: vendor.id
    )
    day_inputs.each do |di|
      if di.inputable_type == DayInputType::Ingredient
        po.procurement_items.create!(
          ingredient_id: di.inputable_id, 
          quantity: di.expected_qty,
          unit: di.unit
        )
      end
    end
  end
end