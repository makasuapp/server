require 'test_helper'

class InventoryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @yesterday = DateTime.now - 1.day
    salt = ingredients(:salt)
    @salt_ingredient = DayIngredient.create!(
      expected_qty: 1.5, had_qty: 0.5, ingredient_id: salt.id, 
      op_day_id: op_days(:today).id, qty_updated_at: @yesterday
    )
    chicken = ingredients(:chicken)
    @chicken_ingredient = DayIngredient.create!(
      expected_qty: 2.5, ingredient_id: chicken.id, op_day_id: op_days(:today).id
    )
  end

  test "save_qty updates qty of ingredients that exist" do
    now = DateTime.now.to_i
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: now}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now}
    updates << {id: 0, had_qty: 2, time: now}

    post "/api/inventory/save_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 1.2
    assert @salt_ingredient.qty_updated_at.to_i == now
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now
  end

  test "save_qty updates to latest" do
    now = DateTime.now
    updates = []
    updates << {id: @salt_ingredient.id, had_qty: 1.2, time_sec: (now - 2.days).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 2.hours).to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2.5, time_sec: now.to_i}
    updates << {id: @chicken_ingredient.id, had_qty: 2, time_sec: (now - 1.hour).to_i}

    post "/api/inventory/save_qty", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt_ingredient.reload.had_qty == 0.5
    assert @salt_ingredient.qty_updated_at.to_i == @yesterday.to_i
    assert @chicken_ingredient.reload.had_qty == 2.5
    assert @chicken_ingredient.qty_updated_at.to_i == now.to_i
  end
end