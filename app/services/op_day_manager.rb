# typed: strict

class OpDayManager
  extend T::Sig

  #TODO: would be better if we had an update mechanism that didn't involve deleting all 
  #TODO: maybe we should re-use ids?
  #re-generate the day's prep/inputs
  sig {params(op_day: OpDay).void}
  def self.update_day_for(op_day)
    prep_made_amounts = self.prep_made_amounts(op_day)
    input_had_amounts = self.input_had_amounts(op_day)

    #clear existing
    op_day.day_inputs.delete_all
    op_day.day_preps.delete_all

    #TODO(timezone)
    start_date = op_day.date.in_time_zone("America/Toronto").beginning_of_day
    end_date = start_date.end_of_day
    predicted_orders = PredictedOrder
      .where(date: start_date..end_date)
      .where(kitchen_id: op_day.kitchen_id)

    #regenerate for all recipes of that date 
    self.create_day(predicted_orders, op_day, input_had_amounts, prep_made_amounts)
  end

  sig {params(input: T.any(InputAmount, DayInput)).returns(String)}
  def self.input_map_key(input)
    "#{input.inputable_type}#{input.inputable_id}"
  end

  PrepMadeAmounts = T.type_alias { T::Hash[Integer, T.nilable(T::Hash[Integer, T.nilable(StepAmount)])] }
  #assumes prev day preps already properly aggregated
  sig {params(op_day: OpDay).returns(OpDayManager::PrepMadeAmounts)}
  def self.prep_made_amounts(op_day)
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

  InputHadAmounts = T.type_alias { T::Hash[String, T.nilable(T::Hash[Integer, T.nilable(T::Array[InputAmount])])] }
  sig {params(op_day: OpDay).returns(OpDayManager::InputHadAmounts)}
  def self.input_had_amounts(op_day)
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

        had_qty = input.had_qty
        #assumes prev day input ingredients are properly aggregated since those had to come from us
        #day input recipes can be from user input and might not be aggregated
        if input.inputable_type == DayInputType::Recipe
          existing = input_map[map_key][day_needed_at_i].first

          if existing.present?
            had_qty = UnitConverter.convert(existing.quantity, existing.unit, input.unit) + had_qty
          end
        end

        input_map[map_key][day_needed_at_i][0] = InputAmount.mk(
          input.inputable_id, input.inputable_type, input.min_needed_at, 
          had_qty, input.unit)
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
    input_had_amounts: OpDayManager::InputHadAmounts,
    prep_made_amounts: OpDayManager::PrepMadeAmounts
    ).void} 
  def self.create_day(predicted_orders, op_day, input_had_amounts, prep_made_amounts)
    day_preps_map = {}
    day_inputs_map = {}
    recipe_deductions = T.let({}, T::Hash[Integer, T.nilable(InputAmount)])

    #add in had recipes first, those will definitely be the same + we need to deduct from them
    recipe_had_amounts = input_had_amounts.values
      .map { |x| T.must(x).values }
      .flatten.compact
      .select { |input| input.inputable_type == DayInputType::Recipe }
    recipe_had_amounts.each do |recipe_had_amount|
      recipe_map_key = self.input_map_key(recipe_had_amount)
      day_needed_at_i = recipe_had_amount.min_needed_at.to_i

      if day_inputs_map[recipe_map_key].nil?
        day_inputs_map[recipe_map_key] = {}
      end

      day_inputs_map[recipe_map_key][day_needed_at_i] = [
        DayInput.new(
          inputable_id: recipe_had_amount.inputable_id,
          inputable_type: recipe_had_amount.inputable_type,
          #should expected just be what had?
          expected_qty: recipe_had_amount.quantity,
          unit: recipe_had_amount.unit,
          op_day_id: op_day.id,
          min_needed_at: recipe_had_amount.min_needed_at,
          had_qty: recipe_had_amount.quantity,
          kitchen_id: op_day.kitchen_id
        ) 
      ]

      recipe_deductions[recipe_had_amount.inputable_id] = recipe_had_amount
    end

    predicted_orders.includes(:recipe).each do |po|
      recipe = po.recipe
      for_date = po.date
      recipe_servings = recipe.servings_produced(po.quantity)

      subrecipe_step_amounts, input_amounts, curr_recipe_deductions = recipe.component_amounts(for_date, 
        recipe_deductions: recipe_deductions, recipe_servings: recipe_servings)
      recipe_deductions = curr_recipe_deductions

      #aggregate into day preps
      subrecipe_step_amounts.each do |step_amount|
        recipe_step_id = step_amount.recipe_step_id
        additional_qty = step_amount.quantity 

        if day_preps_map[recipe_step_id].nil?
          day_preps_map[recipe_step_id] = {}
        end

        #add together ones from the same time
        min_needed_at_i = step_amount.min_needed_at.to_i
        existing_prep = day_preps_map[recipe_step_id][min_needed_at_i]
        if existing_prep.nil?
          made_amounts = prep_made_amounts[step_amount.recipe_step_id]
          if made_amounts.present?
            made_amount = made_amounts[min_needed_at_i]
            if made_amount.present?
              made_qty = made_amount.quantity
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

        input_qty = i_amount.quantity

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
          had_amounts = input_had_amounts[map_key] && T.must(input_had_amounts[map_key])[day_needed_at_i]
          if had_amounts.present?
            had_amount = had_amounts.find { |i| 
              UnitConverter.can_convert?(i.unit, i_amount.unit, input.volume_weight_ratio) }
            if had_amount.present?
              had_qty = UnitConverter.convert(had_amount.quantity, had_amount.unit,
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