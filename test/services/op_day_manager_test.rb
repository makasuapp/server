require 'test_helper'

class OpDayManagerCreateDayTest < ActiveSupport::TestCase
  setup do
    @kitchen = kitchens(:test)
    @predicted_order = predicted_orders(:chicken)
    @today = op_days(:today)

    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)

    @green_onion_step = recipe_steps(:green_onion_p1)
    @chicken_step = recipe_steps(:chicken_p2)
    @sauce_step = recipe_steps(:sauce_p2)

    @g = recipes(:green_onion)
    @p = recipes(:prep_chicken)

    #TODO(@timezone)
    @time = DateTime.now.in_time_zone("America/Toronto").beginning_of_day

    @had_amounts = {}
    @had_amounts["#{DayInputType::Ingredient}#{@i2.id}"] = {}
    @had_amounts["#{DayInputType::Recipe}#{@g.id}"] = {}
    @had_amounts["#{DayInputType::Recipe}#{@p.id}"] = {}
  end

  test "adds had_amount to ingredients if exists" do
    count = DayInput.count
    assert PredictedOrder.count == 1

    amounts = [
      InputAmount.mk(@i1.id, DayInputType::Ingredient, @time, 1.5),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, @time, 1400, "g")
    ]
    Recipe.any_instance.expects(:component_amounts).once
      .with(anything, recipe_deductions: {}, recipe_servings: 2)
      .returns([[], amounts, {}])
    @had_amounts["#{DayInputType::Ingredient}#{@i2.id}"][@time.to_i] = [InputAmount.mk(@i2.id, DayInputType::Ingredient, @time, 1.2, "kg")]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    assert DayInput.count == count + 2

    di1 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient).first
    assert di1.expected_qty == 1.5 
    assert di1.had_qty.nil?

    di2 = DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).first
    assert di2.expected_qty == 1400
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

    amounts = [
      #doesn't aggregate, different day
      InputAmount.mk(@i1.id, DayInputType::Ingredient, @time - 1.day, 1.5, "g"),
      #should aggregate
      InputAmount.mk(@i1.id, DayInputType::Ingredient, @time.beginning_of_day + 1.hour, 1.5, "g"),
      InputAmount.mk(@i1.id, DayInputType::Ingredient, @time, 1.3, "g"),
      #doesn't aggregate, can't convert
      InputAmount.mk(@i1.id, DayInputType::Ingredient, @time, 1.2, "L"),
      #all aggregates
      InputAmount.mk(@i2.id, DayInputType::Ingredient, @time, 1.4, "kg"),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, @time, 1100, "g"),
      InputAmount.mk(@i2.id, DayInputType::Ingredient, @time, 1.6, "L")
    ]
    Recipe.any_instance.expects(:component_amounts).times(2)
      .with(anything, recipe_deductions: {}, recipe_servings: 2)
      .returns([[], amounts, {}])

    OpDayManager.create_day(PredictedOrder.all, @today, {}, {})

    assert DayInput.count == count + 4
    assert DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient).count == 3
    assert DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).count == 1

    di1_yesterday = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where("min_needed_at < ?", @time.beginning_of_day).first
    assert di1_yesterday.expected_qty == 1.5 * 2
    assert di1_yesterday.unit == "g"
    
    di1_1 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where(min_needed_at: @time.beginning_of_day).first
    assert di1_1.expected_qty == (1.5 + 1.3) * 2
    assert di1_1.unit == "g"

    di1_2 = DayInput.where(inputable_id: @i1.id, inputable_type: DayInputType::Ingredient)
      .where(min_needed_at: @time.beginning_of_day).last
    assert di1_2.expected_qty == 1.2 * 2
    assert di1_2.unit == "L"

    di2 = DayInput.where(inputable_id: @i2.id, inputable_type: DayInputType::Ingredient).first
    assert di2.expected_qty.round(4) == (((1100.0/1000) + 1.4 + (1.6 * @i2.volume_weight_ratio)) * 2).round(4)
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

    green_onion_step = g.recipe_steps.latest.first
    green_onion_prep = DayPrep.where(recipe_step_id: green_onion_step.id).order(:min_needed_at)
    assert green_onion_prep.count == 2
    assert green_onion_prep.first.expected_qty.round(3) == (7.0/2 * ((3.0 * 6)/100)).round(3)
    assert green_onion_prep.last.expected_qty.round(3) == (7.0/2 * ((0.5 * 10)/100 + 80.0/100)).round(3)
  end

  test "had_amount of recipes removes ingredients/preps needed for them" do
    OpDayManager.create_day(PredictedOrder.all, @today, {}, {})

    green_onion_input_before = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: @i2.id).first
    #4x chicken needs 2x green onion
    assert green_onion_input_before.expected_qty == 80 * 2
    assert green_onion_input_before.unit == "g"

    green_onion_before = DayPrep.where(recipe_step_id: @green_onion_step.id).first
    assert green_onion_before.expected_qty == 0.8 * 2

    prep_chicken_before = DayInput.where(inputable_type: DayInputType::Recipe,
      inputable_id: @p.id).first
    assert prep_chicken_before.had_qty == nil
    assert prep_chicken_before.expected_qty == 2

    DayInput.delete_all
    DayPrep.delete_all

    #have a bit of green onion, don't need to make it all
    @had_amounts["#{DayInputType::Recipe}#{@g.id}"][@time.to_i] = [
      InputAmount.mk(@g.id, DayInputType::Recipe, @time, 40, "g")
    ]
    #already expecting prep chicken from component_amounts, doesn't change anything
    @had_amounts["#{DayInputType::Recipe}#{@p.id}"][@time.to_i] = [
      InputAmount.mk(@p.id, DayInputType::Recipe, @time, 2)
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    green_onion_input_after = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: @i2.id).first
    assert green_onion_input_after.expected_qty.round(1) == 120
    assert green_onion_input_after.unit == "g"

    green_onion_after = DayPrep.where(recipe_step_id: @green_onion_step.id).first
    assert green_onion_after.expected_qty.round(2) == 1.2

    prep_chicken_after = DayInput.where(inputable_type: DayInputType::Recipe,
      inputable_id: @p.id).first
    assert prep_chicken_after.had_qty == 2
    assert prep_chicken_after.expected_qty == 2

    recipe = DayInput.where(inputable_type: DayInputType::Recipe, 
      inputable_id: @g.id).first
    assert recipe.had_qty == 40
    assert recipe.unit == "g"
  end

  test "had_amount of recipe more than needed" do
    @had_amounts["#{DayInputType::Recipe}#{@g.id}"][@time.to_i] = [
      InputAmount.mk(@g.id, DayInputType::Recipe, @time, 1, "kg")
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    green_onion_input_after = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: @i2.id).first
    assert green_onion_input_after.nil?

    green_onion_after = DayPrep.where(recipe_step_id: @green_onion_step.id).first
    assert green_onion_after.nil?

    recipe = DayInput.where(inputable_type: DayInputType::Recipe, 
      inputable_id: @g.id).first
    assert recipe.had_qty == 1
    assert recipe.unit == "kg"
  end

  test "had_amount of recipe generated from component_amounts less than generated reflects in had_qty" do
    @had_amounts["#{DayInputType::Recipe}#{@p.id}"][@time.to_i] = [
      InputAmount.mk(@p.id, DayInputType::Recipe, @time, 0)
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    recipe = DayInput.where(inputable_type: DayInputType::Recipe, 
      inputable_id: @p.id).first
    assert recipe.had_qty == 0
    assert recipe.expected_qty > 0
  end

  test "had_amount of recipe that's not in predicted orders' subrecipes shouldn't reduce inputs/prep" do
    new_recipe = @g.dup
    new_recipe.name = "Different recipe using green onions"
    new_recipe.save!

    @had_amounts["#{DayInputType::Recipe}#{new_recipe.id}"] = {}
    @had_amounts["#{DayInputType::Recipe}#{new_recipe.id}"][@time.to_i] = [
      InputAmount.mk(new_recipe.id, DayInputType::Recipe, @time, 40, "g")
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    green_onion_input_after = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: @i2.id).first
    assert green_onion_input_after.expected_qty.round(1) == 160
    assert green_onion_input_after.unit == "g"

    green_onion_after = DayPrep.where(recipe_step_id: @green_onion_step.id).first
    assert green_onion_after.expected_qty.round(2) == 1.6

    recipe = DayInput.where(inputable_type: DayInputType::Recipe, 
      inputable_id: new_recipe.id).first
    assert recipe.had_qty == 40
    assert recipe.unit == "g"
  end

  test "had_amount of recipe greater than needed in predicted orders' subrecipes shouldn't reduce related inputs" do
    #we need 10g of green onion not chopped in recipe now
    StepInput.create!(inputable_id: @i2.id, inputable_type: StepInputType::Ingredient, 
      recipe_step_id: @sauce_step.id, quantity: 10, unit: "g")

    @had_amounts["#{DayInputType::Recipe}#{@g.id}"][@time.to_i] = [
      InputAmount.mk(@g.id, DayInputType::Recipe, @time, 1, "kg")
    ]
    OpDayManager.create_day(PredictedOrder.all, @today, @had_amounts, {})

    #no more of the step as expected
    green_onion_after = DayPrep.where(recipe_step_id: @green_onion_step.id).first
    assert green_onion_after.nil?

    #but still need 10g from other subrecipe
    green_onion_input_after = DayInput.where(inputable_type: DayInputType::Ingredient,
      inputable_id: @i2.id).first
    assert green_onion_input_after.expected_qty == 10
    assert green_onion_input_after.unit == "g"
  end

  test "input_had_amounts aggregates multiple of the same recipe" do
    DayInput.create!(
      expected_qty: 2.5, inputable_id: @g.id, 
      inputable_type: DayInputType::Recipe,
      op_day_id: @today.id, qty_updated_at: @time,
      min_needed_at: @time, kitchen_id: @kitchen.id
    )
    DayInput.create!(
      expected_qty: 2.5, had_qty: 1.5, inputable_id: @g.id, 
      inputable_type: DayInputType::Recipe,
      op_day_id: @today.id, qty_updated_at: @time,
      min_needed_at: @time, kitchen_id: @kitchen.id
    )
    DayInput.create!(
      expected_qty: 2.7, had_qty: 2.7, inputable_id: @g.id, 
      inputable_type: DayInputType::Recipe,
      op_day_id: @today.id, qty_updated_at: @time,
      min_needed_at: @time, kitchen_id: @kitchen.id
    )
    had_amounts = OpDayManager.input_had_amounts(@today)
    assert had_amounts["#{DayInputType::Recipe}#{@g.id}"][@time.to_i].first.quantity == 4.2
  end
end
