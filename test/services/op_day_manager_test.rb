require 'test_helper'

class OpDayManagerCreateDayTest < ActiveSupport::TestCase
  setup do
    @predicted_order = predicted_orders(:chicken)
    @today = op_days(:today)
    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)
    @sauce_step = recipe_steps(:sauce_p2)
    @chicken_step = recipe_steps(:chicken_p2)
    @prep_recipe = recipes(:sauce)
  end

  test "adds had_amount to ingredients if exists" do
    count = DayInput.count
    assert PredictedOrder.count == 1

    #TODO(timezone)
    time = DateTime.now.in_time_zone("America/Toronto").beginning_of_day
    amounts = [
      InputAmount.mk(@i1.id, DayInputType::Ingredient, time, 1.5),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, time, 1400, "g")
    ]
    Recipe.any_instance.expects(:component_amounts).once.returns([[], amounts])
    had_amounts = {}
    had_amounts["#{DayInputType::Ingredient}#{@i2.id}"] = {}
    had_amounts["#{DayInputType::Ingredient}#{@i2.id}"][time.to_i] = [InputAmount.mk(@i2.id, DayInputType::Ingredient, time, 1.2, "kg")]
    OpDayManager.create_day(PredictedOrder.all, @today, had_amounts, {})

    assert DayInput.count == count + 2

    di1 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient).first
    #4 qty orders, each recipe produces 2 servings
    assert di1.expected_qty == 1.5 * 2
    assert di1.had_qty.nil?

    di2 = DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).first
    assert di2.expected_qty == 1400 * 2
    assert di2.had_qty == 1200
    assert di2.unit == "g"
  end

  test "aggregates the ingredients across the day" do
    new_pr = @predicted_order.dup
    new_pr.save!
    count = DayInput.count
    assert PredictedOrder.count == 2

    assert @i1.volume_weight_ratio.nil?
    assert @i2.volume_weight_ratio.present?

    time = DateTime.now.in_time_zone("America/Toronto")
    amounts = [
      #doesn't aggregate, different day
      InputAmount.mk(@i1.id, DayInputType::Ingredient, time - 1.day, 1.5, "g"),
      #should aggregate
      InputAmount.mk(@i1.id, DayInputType::Ingredient, time.beginning_of_day + 1.hour, 1.5, "g"),
      InputAmount.mk(@i1.id, DayInputType::Ingredient, time, 1.3, "g"),
      #doesn't aggregate, can't convert
      InputAmount.mk(@i1.id, DayInputType::Ingredient, time, 1.2, "L"),
      #all aggregates
      InputAmount.mk(@i2.id, DayInputType::Ingredient, time, 1.4, "kg"),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, time, 1100, "g"),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, time, 1.6, "L")
    ]
    Recipe.any_instance.expects(:component_amounts).times(2).returns([[], amounts])
    OpDayManager.create_day(PredictedOrder.all, @today, {}, {})

    assert DayInput.count == count + 4
    assert DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient).count == 3
    assert DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).count == 1

    di1_yesterday = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where("min_needed_at < ?", time.beginning_of_day).first
    assert di1_yesterday.expected_qty == 1.5 * 2 * 2
    assert di1_yesterday.unit == "g"
    
    di1_1 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where(min_needed_at: time.beginning_of_day).first
    assert di1_1.expected_qty == (1.5 + 1.3) * 2 * 2
    assert di1_1.unit == "g"

    di1_2 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where(min_needed_at: time.beginning_of_day).last
    assert di1_2.expected_qty == 1.2 * 2 * 2
    assert di1_2.unit == "L"

    di2 = DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).first
    assert di2.expected_qty.round(4) == (((1100.0/1000) + 1.4 + (1.6 * @i2.volume_weight_ratio)) * 2 * 2).round(4)
    assert di2.unit == "kg"
  end

  test "adds made_amount to prep if exists" do
    count = DayPrep.count

    made_amounts = {}
    made_amounts[@sauce_step.id] = {}
    min_needed_at = @predicted_order.date.in_time_zone("America/Toronto")
    made_amounts[@sauce_step.id][min_needed_at.to_i] = StepAmount.mk(@sauce_step.id, PredictedOrder.first.date, 0.8)
    OpDayManager.create_day(PredictedOrder.all, @today, {}, made_amounts)

    assert DayPrep.count == count + 6
    sauce_prep = DayPrep.where(recipe_step_id: @sauce_step.id).first
    assert sauce_prep.expected_qty == 4 / 4
    assert sauce_prep.made_qty == 0.8

    chicken_prep = DayPrep.where(recipe_step_id: @chicken_step.id).first
    assert chicken_prep.expected_qty == 4 / 2
    assert chicken_prep.made_qty.nil?
  end

  test "aggregates the steps" do
    g = recipes(:green_onion)

    #green onion is now a subrecipe of chicken twice and sauce once
    #one of the chicken ones has an earlier min_needed_at
    StepInput.create!(inputable_id: g.id, inputable_type: StepInputType::Recipe, 
      recipe_step_id: @sauce_step.id, quantity: 10, unit: "g")
    StepInput.create!(inputable_id: g.id, inputable_type: StepInputType::Recipe, 
      recipe_step_id: @chicken_step.id, quantity: 3, unit: "tbsp")

    count = DayPrep.count

    #7 total now
    new_pr = @predicted_order.dup
    new_pr.quantity = 3
    new_pr.save!

    OpDayManager.create_day(PredictedOrder.all, @today, {}, {})

    assert DayPrep.count == count + 7
    #recipe serves 2, so we want 7/2 of it
    assert DayPrep.where(recipe_step_id: @chicken_step.id).first.expected_qty == 3.5

    green_onion_step = g.recipe_steps.first
    green_onion_prep = DayPrep.where(recipe_step_id: green_onion_step.id).order(:min_needed_at)
    assert green_onion_prep.count == 2
    assert green_onion_prep.first.expected_qty.round(3) == (7.0/2 * ((3.0 * 6)/100)).round(3)
    assert green_onion_prep.last.expected_qty.round(3) == (7.0/2 * ((0.5 * 10)/100 + 80.0/100)).round(3)
  end

  test "had_amount of recipes removes ingredients/preps needed for them" do
    time = DateTime.now.in_time_zone("America/Toronto").beginning_of_day

    sesame_paste = ingredients(:sesame_paste)
    sauce_step = recipe_steps(:sauce_p2)

    OpDayManager.create_day(PredictedOrder.all, @today, {}, {})

    paste_input_before = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: sesame_paste.id).first
    #4x chicken needs 1x sauce
    assert paste_input_before.expected_qty == 3

    sauce_step_before = DayPrep.where(recipe_step_id: sauce_step.id).first
    assert sauce_step_before.expected_qty == 1

    DayInput.delete_all
    DayPrep.delete_all

    had_amounts = {}
    had_amounts["#{DayInputType::Recipe}#{@prep_recipe.id}"] = {}
    had_amounts["#{DayInputType::Recipe}#{@prep_recipe.id}"][time.to_i] = [
      InputAmount.mk(@prep_recipe.id, DayInputType::Recipe, time, 0.5)
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, had_amounts, {})

    paste_input_after = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: sesame_paste.id).first
    assert paste_input_after.expected_qty == 1.5

    sauce_step_after = DayPrep.where(recipe_step_id: sauce_step.id).first
    assert sauce_step_after.expected_qty == 0.5
  end

  #TODO: we don't handle this case right now
  test "had_amount of recipe that's not in predicted orders' subrecipes shouldn't reduce inputs/prep" do
  end

  #TODO: how do we want to handle this case?
  test "had_amount of recipe generated from component_amounts" do
    #day originally would have brined chicken added as day input since needed prep day before
    #have day input with recipe brined chicken, had_amount = 0
    #now day also needs to make brined chicken...?
  end
end
