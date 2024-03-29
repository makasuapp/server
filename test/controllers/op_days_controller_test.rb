# typed: false
require 'test_helper'

class OpDaysControllerInputsTest < ActionDispatch::IntegrationTest
  setup do
    @yesterday = DateTime.now - 1.day
    salt = ingredients(:salt)
    @kitchen = kitchens(:test)
    @op_day = op_days(:today)
    @salt_ingredient = DayInput.create!(
      expected_qty: 1.5, had_qty: 0.5, inputable_id: salt.id, 
      inputable_type: DayInputType::Ingredient,
      op_day_id: @op_day.id, qty_updated_at: @yesterday,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
    chicken = ingredients(:chicken)
    @chicken_ingredient = DayInput.create!(
      expected_qty: 2.5, inputable_id: chicken.id, 
      inputable_type: DayInputType::Ingredient,
      op_day_id: @op_day.id,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
    recipe = recipes(:sauce)
    @recipe_input = DayInput.create!(
      expected_qty: 1.5, inputable_id: recipe.id, 
      inputable_type: DayInputType::Recipe,
      op_day_id: @op_day.id, qty_updated_at: @yesterday,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
  end

  test "save_inputs_qty updates qty of ingredients that exist" do
    now = DateTime.now.to_i
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: now}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now}
    updates << {id: 0, had_qty: 2, time: now}

    post "/api/op_days/save_inputs_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 1.2
    assert @salt_ingredient.qty_updated_at.to_i == now
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now
  end

  test "save_inputs_qty updates to latest" do
    now = DateTime.now
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: (now - 2.days).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 2.hours).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now.to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 1.hour).to_i}

    post "/api/op_days/save_inputs_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 0.5
    assert @salt_ingredient.qty_updated_at.to_i == @yesterday.to_i
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now.to_i
  end

  test "save_inputs_qty of recipes triggers updating the day again" do
    now = DateTime.now
    updates = []
    updates << {id: @recipe_input.id, had_qty: 0.5, time_sec: now.to_i}

    OpDayManager.expects(:update_day_for).once
    post "/api/op_days/save_inputs_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @recipe_input.reload.had_qty == 0.5
  end
end

class OpDaysControllerPrepTest < ActionDispatch::IntegrationTest
  setup do
    @yesterday = DateTime.now - 1.day
    chicken_p1 = recipe_steps(:chicken_p1)
    chicken_p2 = recipe_steps(:chicken_p2)
    @kitchen = kitchens(:test)
    @p1_prep = DayPrep.create!(
      expected_qty: 1.5, made_qty: 0.5, recipe_step_id: chicken_p1.id, 
      op_day_id: op_days(:today).id, qty_updated_at: @yesterday,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
    @p2_prep = DayPrep.create!(
      expected_qty: 2.5, recipe_step_id: chicken_p2.id, op_day_id: op_days(:today).id,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
  end

  test "save_prep_qty updates qty of prep that exist" do
    now = DateTime.now.to_i
    updates = []
    updates << {id: @p1_prep.id, made_qty: 1.2, time_sec: now}
    updates << {id: @p2_prep.id, made_qty: 2.5, time_sec: now}
    updates << {id: 0, made_qty: 2, time: now}

    post "/api/op_days/save_prep_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @p1_prep.reload.made_qty == 1.2
    assert @p1_prep.qty_updated_at.to_i == now
    assert @p2_prep.reload.made_qty == 2.5
    assert @p2_prep.qty_updated_at.to_i == now
  end

  test "save_prep_qty updates to latest" do
    now = DateTime.now
    updates = []
    updates << {id: @p1_prep.id, made_qty: 1.2, time_sec: (now - 2.days).to_i}
    updates << {id: @p2_prep.id, made_qty: 2, time_sec: (now - 2.hours).to_i}
    updates << {id: @p2_prep.id, made_qty: 2.5, time_sec: now.to_i}
    updates << {id: @p2_prep.id, made_qty: 2, time_sec: (now - 1.hour).to_i}

    post "/api/op_days/save_prep_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @p1_prep.reload.made_qty == 0.5
    assert @p1_prep.qty_updated_at.to_i == @yesterday.to_i
    assert @p2_prep.reload.made_qty == 2.5
    assert @p2_prep.qty_updated_at.to_i == now.to_i
  end

  test "index doesn't show old prep" do
    op_day = op_days(:today)
    OpDayManager.update_day_for(op_day)

    get api_op_days_url(kitchen_id: @kitchen.id)
    assert_response 200

    body = JSON.parse(@response.body)

    assert !body["recipes"].empty?
    assert !body["ingredients"].empty?
    assert !body["recipe_steps"].empty?
    assert !body["predicted_orders"].empty?
    assert !body["prep"].empty?
    assert !body["inputs"].empty?

    old_prep = recipe_steps(:old_green_onion_p1)
    assert body["recipe_steps"].select { |x| x["id"] == old_prep.id}.empty?
  end

  test "index shows old prep if it's included in a day prep" do
    old_prep = recipe_steps(:old_green_onion_p1)
    @p1_prep.update_attributes(recipe_step_id: old_prep.id)
    get api_op_days_url(kitchen_id: @kitchen.id, date: @yesterday.to_i)
    assert_response 200

    body = JSON.parse(@response.body)
    assert body["recipe_steps"].select { |x| x["id"] == old_prep.id}.first.present?
  end
end

class OpDaysControllerRecipeTest < ActionDispatch::IntegrationTest
  setup do
    @kitchen = kitchens(:test)
    @op_day = op_days(:today)
    @c = recipes(:chicken)
    @g = recipes(:green_onion)
  end

  test "add recipe inputs should update day" do
    count = DayInput.count

    OpDayManager.expects(:update_day_for).once
    post "/api/op_days/add_inputs", params: { 
      kitchen_id: @kitchen.id,
      inputs: [
        {qty: 3, inputable_type: DayInputType::Recipe, inputable_id: @c.id},
        {qty: 10, unit: "g", inputable_type: DayInputType::Recipe, inputable_id: @g.id}
      ] 
    }, as: :json

    assert_response 201
    assert DayInput.count == count + 2

    chicken_input = DayInput.where(inputable_type: DayInputType::Recipe, inputable_id: @c.id)
    assert chicken_input.count == 1
    c = chicken_input.first
    assert c.expected_qty == 3
    assert c.had_qty == 3
    assert c.unit == nil

    green_onion_input = DayInput.where(inputable_type: DayInputType::Recipe, inputable_id: @g.id)
    assert green_onion_input.count == 1
    g = green_onion_input.first
    assert g.expected_qty == 10
    assert g.had_qty == 10
    assert g.unit == "g"
  end
end