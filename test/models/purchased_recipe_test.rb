# typed: false
# == Schema Information
#
# Table name: purchased_recipes
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_purchased_recipes_on_date                 (date)
#  index_purchased_recipes_on_date_and_kitchen_id  (date,kitchen_id)
#  index_purchased_recipes_on_recipe_id            (recipe_id)
#
require 'test_helper'

class PurchasedRecipeTest < ActiveSupport::TestCase
  setup do
    @purchased_recipe = purchased_recipes(:chicken)
    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)
  end

  test "ingredient_amounts returns ingredients needed by purchased recipe quantity" do
    #recipe serves 2, we want 4, so just 2x
    assert @purchased_recipe.quantity == 4
    assert @purchased_recipe.recipe.output_qty == 2

    amounts = [
      IngredientAmount.mk(@i1.id, 1.5),
      IngredientAmount.mk(@i2.id, 2.5),
      IngredientAmount.mk(@i2.id, 1.4)
    ]
    Recipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    pr_amounts = @purchased_recipe.ingredient_amounts

    assert pr_amounts[0].serialize == IngredientAmount.mk(@i1.id, 3.0).serialize
    assert pr_amounts[1].serialize == IngredientAmount.mk(@i2.id, 5.0).serialize
    assert pr_amounts[2].serialize == IngredientAmount.mk(@i2.id, 2.8).serialize
  end
end
