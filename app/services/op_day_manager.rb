# typed: strict

class OpDayManager
  extend T::Sig

  #TODO: would be better if we had an update mechanism that didn't involve deleting all 
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

  #assumes prev day inputs already properly aggregated
  sig {params(op_day: OpDay).returns(T::Hash[String, T::Array[InputAmount]])}
  def self.input_had_qtys(op_day)
    op_day.day_inputs.inject({}) do |input_map, input|
      #same map key as create_day, not great that it's diff method
      map_key = "#{input.inputable_type}#{input.inputable_id}"
      if input.had_qty.present?
        if input_map[map_key].nil?
          input_map[map_key] = []
        end

        input_map[map_key] << InputAmount.mk(
          input.inputable_id, input.inputable_type, input.min_needed_at, input.had_qty, input.unit)
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
    input_had_qtys: T::Hash[String, T::Array[InputAmount]], 
    prep_made_qtys: T::Hash[Integer, T::Array[StepAmount]]
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

      #aggregate into day inputs
      input_amounts.each do |i_amount|
        map_key = "#{i_amount.inputable_type}#{i_amount.inputable_id}"
        input_qty = i_amount.quantity * recipe_servings
        #TODO(timezone)
        #TODO: this time is a bit arbitrary and is set here + in op_days_controller
        on_date = i_amount.min_needed_at.in_time_zone("America/Toronto").beginning_of_day

        if day_inputs_map[map_key].nil?
          day_inputs_map[map_key] = []
        end

        input = i_amount.inputable
        matches_idx  = day_inputs_map[map_key].find_index { |i| 
          i.min_needed_at.to_i == on_date.to_i &&
          UnitConverter.can_convert?(i.unit, i_amount.unit, input.volume_weight_ratio) }
        if matches_idx.nil?
          had_qty_amounts = input_had_qtys[map_key]
          if had_qty_amounts.present?
            matches_unit_amount = had_qty_amounts.find { |i| 
              UnitConverter.can_convert?(i.unit, i_amount.unit, input.volume_weight_ratio) &&
              i.min_needed_at.to_i == on_date.to_i }
            if matches_unit_amount.present?
              had_qty = UnitConverter.convert(matches_unit_amount.quantity, matches_unit_amount.unit,
                i_amount.unit, input.volume_weight_ratio)
            end
          end

          day_inputs_map[map_key] << DayInput.new(
            inputable_id: i_amount.inputable_id,
            inputable_type: i_amount.inputable_type,
            expected_qty: input_qty,
            unit: i_amount.unit,
            op_day_id: op_day.id,
            min_needed_at: on_date,
            had_qty: had_qty,
            kitchen_id: op_day.kitchen_id
          )
        else
          existing_input = day_inputs_map[map_key][matches_idx]
          additional_qty = UnitConverter.convert(input_qty, i_amount.unit,
            existing_input.unit, input.volume_weight_ratio)
          existing_input.expected_qty = existing_input.expected_qty + additional_qty

          day_inputs_map[map_key][matches_idx] = existing_input
        end
      end
    end

    DayInput.import! day_inputs_map.values.flatten
    DayPrep.import! day_preps_map.values.flatten
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