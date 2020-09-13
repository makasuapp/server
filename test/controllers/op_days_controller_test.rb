# typed: false
require 'test_helper'

class OpDaysControllerSaveIngredientsTest < ActionDispatch::IntegrationTest
  setup do
    @yesterday = DateTime.now - 1.day
    salt = ingredients(:salt)
    @kitchen = kitchens(:test)
    @salt_ingredient = DayIngredient.create!(
      expected_qty: 1.5, had_qty: 0.5, ingredient_id: salt.id, 
      op_day_id: op_days(:today).id, qty_updated_at: @yesterday,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
    chicken = ingredients(:chicken)
    @chicken_ingredient = DayIngredient.create!(
      expected_qty: 2.5, ingredient_id: chicken.id, op_day_id: op_days(:today).id,
      min_needed_at: @yesterday, kitchen_id: @kitchen.id
    )
  end

  test "save_ingredients_qty updates qty of ingredients that exist" do
    now = DateTime.now.to_i
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: now}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now}
    updates << {id: 0, had_qty: 2, time: now}

    post "/api/op_days/save_ingredients_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 1.2
    assert @salt_ingredient.qty_updated_at.to_i == now
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now
  end

  test "save_ingredients_qty updates to latest" do
    now = DateTime.now
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: (now - 2.days).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 2.hours).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now.to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 1.hour).to_i}

    post "/api/op_days/save_ingredients_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 0.5
    assert @salt_ingredient.qty_updated_at.to_i == @yesterday.to_i
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now.to_i
  end
end

class OpDaysControllerSavePrepTest < ActionDispatch::IntegrationTest
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
end