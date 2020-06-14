require 'test_helper'

class InventoryControllerTest < ActionDispatch::IntegrationTest
  test "action" do
    salt = ingredients(:salt)
    day_ingredient = DayIngredient.create!(expected_qty: 1.5, ingredient_id: salt.id, op_day_id: op_days(:today).id)

    post "/api/inventory/#{day_ingredient.id}/save_qty", params: { 
      day_ingredient: {
        had_qty: 1.2
      },
    }, as: :json

    assert_response 200
    assert day_ingredient.reload.had_qty == 1.2
  end
end