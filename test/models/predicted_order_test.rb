# typed: false
# == Schema Information
#
# Table name: predicted_orders
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint           not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_predicted_orders_on_date                 (date)
#  index_predicted_orders_on_date_and_kitchen_id  (date,kitchen_id)
#  index_predicted_orders_on_recipe_id            (recipe_id)
#
require 'test_helper'

class PredictedOrderTest < ActiveSupport::TestCase
  setup do
    @predicted_order = predicted_orders(:chicken)
    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)
  end

  test "ingredient_amounts returns ingredients needed by purchased recipe quantity" do
    #recipe serves 2, we want 4, so just 2x
    assert @predicted_order.quantity == 4
    assert @predicted_order.recipe.output_qty == 2

    amounts = [
      IngredientAmount.mk(@i1.id, 1.5),
      IngredientAmount.mk(@i2.id, 2.5),
      IngredientAmount.mk(@i2.id, 1.4)
    ]
    Recipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    pr_amounts = @predicted_order.ingredient_amounts

    assert pr_amounts[0].serialize == IngredientAmount.mk(@i1.id, 3.0).serialize
    assert pr_amounts[1].serialize == IngredientAmount.mk(@i2.id, 5.0).serialize
    assert pr_amounts[2].serialize == IngredientAmount.mk(@i2.id, 2.8).serialize
  end
end