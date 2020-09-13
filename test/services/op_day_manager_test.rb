require 'test_helper'

class DayIngredientTest < ActiveSupport::TestCase
  setup do
    @predicted_order = predicted_orders(:chicken)
    @today = op_days(:today)
    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)
  end

  test "create_day_ingredients adds had_qty if exists" do
    count = DayIngredient.count
    assert PredictedOrder.count == 1

    time = DateTime.now.beginning_of_day
    amounts = [
      IngredientAmount.mk(@i1.id, time, 1.5),
      IngredientAmount.mk(@i2.id, time, 1400, "g")
    ]
    PredictedOrder.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    had_qtys = {}
    had_qtys[@i2.id] = [IngredientAmount.mk(@i2.id, time, 1.2, "kg")]
    OpDayManager.create_day_ingredients(PredictedOrder.all, @today, had_qtys)

    assert DayIngredient.count == count + 2

    di1 = DayIngredient.where(ingredient_id: @i1.id).first
    assert di1.expected_qty == 1.5
    assert di1.had_qty.nil?

    di2 = DayIngredient.where(ingredient_id: @i2.id).first
    assert di2.expected_qty == 1400
    assert di2.had_qty == 1200
    assert di2.unit == "g"
  end

  test "create_day_ingredients aggregates the ingredients across the day" do
    new_pr = @predicted_order.dup
    new_pr.save!
    count = DayIngredient.count
    assert PredictedOrder.count == 2

    assert @i1.volume_weight_ratio.nil?
    assert @i2.volume_weight_ratio.present?

    time = DateTime.now.in_time_zone("America/Toronto")
    amounts = [
      #doesn't aggregate, different day
      IngredientAmount.mk(@i1.id, time - 1.day, 1.5, "g"),
      #should aggregate
      IngredientAmount.mk(@i1.id, time.beginning_of_day + 1.hour, 1.5, "g"),
      IngredientAmount.mk(@i1.id, time, 1.3, "g"),
      #doesn't aggregate, can't convert
      IngredientAmount.mk(@i1.id, time, 1.2, "L"),
      #all aggregates
      IngredientAmount.mk(@i2.id, time, 1.4, "kg"),
      IngredientAmount.mk(@i2.id, time, 1100, "g"),
      IngredientAmount.mk(@i2.id, time, 1.6, "L")
    ]
    PredictedOrder.any_instance.expects(:ingredient_amounts).times(2).returns(amounts)
    OpDayManager.create_day_ingredients(PredictedOrder.all, @today, {})

    assert DayIngredient.count == count + 4
    assert DayIngredient.where(ingredient_id: @i1.id).count == 3
    assert DayIngredient.where(ingredient_id: @i2.id).count == 1

    di1_yesterday = DayIngredient.where(ingredient_id: @i1.id).where("min_needed_at < ?", time.beginning_of_day).first
    assert di1_yesterday.expected_qty == 1.5 * 2
    assert di1_yesterday.unit == "g"
    
    di1_1 = DayIngredient.where(ingredient_id: @i1.id).where(min_needed_at: time.beginning_of_day).first
    assert di1_1.expected_qty == (1.5 + 1.3) * 2
    assert di1_1.unit == "g"

    di1_2 = DayIngredient.where(ingredient_id: @i1.id).where(min_needed_at: time.beginning_of_day).last
    assert di1_2.expected_qty == 1.2 * 2
    assert di1_2.unit == "L"

    di2 = DayIngredient.where(ingredient_id: @i2.id).first
    assert di2.expected_qty.round(4) == (((1100.0/1000) + 1.4 + (1.6 * @i2.volume_weight_ratio)) * 2).round(4)
    assert di2.unit == "kg"
  end
end

class DayPrepTest < ActiveSupport::TestCase
  setup do
    @predicted_order = predicted_orders(:chicken)
    @today = op_days(:today)
    @sauce_step = recipe_steps(:sauce_p2)
    @chicken_step = recipe_steps(:chicken_p2)
  end

  test "create_day_preps adds made_qty if exists" do
    count = DayPrep.count

    made_qtys = {}
    made_qtys[@sauce_step.id] = [StepAmount.mk(@sauce_step.id, PredictedOrder.first.date, 0.8)]
    OpDayManager.create_day_preps(PredictedOrder.all, @today, made_qtys)

    assert DayPrep.count == count + 6
    sauce_prep = DayPrep.where(recipe_step_id: @sauce_step.id).first
    assert sauce_prep.expected_qty == 1
    assert sauce_prep.made_qty == 0.8

    chicken_prep = DayPrep.where(recipe_step_id: @chicken_step.id).first
    assert chicken_prep.expected_qty == 2
    assert chicken_prep.made_qty.nil?
  end

  test "create_day_preps aggregates the steps" do
    g = recipes(:green_onion)

    #green onion is now a subrecipe of chicken twice and sauce once
    #one of the chicken ones has an earlier min_needed_at
    StepInput.create!(inputable_id: g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: @sauce_step.id, quantity: 10, unit: "g")
    StepInput.create!(inputable_id: g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: @chicken_step.id, quantity: 3, unit: "tbsp")

    count = DayPrep.count

    #7 total now
    new_pr = @predicted_order.dup
    new_pr.quantity = 3
    new_pr.save!

    OpDayManager.create_day_preps(PredictedOrder.all, @today, {})

    assert DayPrep.count == count + 7
    #recipe serves 2, so we want 7/2 of it
    assert DayPrep.where(recipe_step_id: @chicken_step.id).first.expected_qty == 3.5

    green_onion_step = g.recipe_steps.first
    green_onion_prep = DayPrep.where(recipe_step_id: green_onion_step.id).order(:min_needed_at)
    assert green_onion_prep.count == 2
    assert green_onion_prep.first.expected_qty.round(3) == (7.0/2 * ((3.0 * 6)/100)).round(3)
    assert green_onion_prep.last.expected_qty.round(3) == (7.0/2 * ((0.5 * 10)/100 + 80.0/100)).round(3)
  end
end