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
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_purchased_recipes_on_date       (date)
#  index_purchased_recipes_on_recipe_id  (recipe_id)
#
require 'test_helper'

class PurchasedRecipeTest < ActiveSupport::TestCase
  setup do
    @purchased_recipe = purchased_recipes(:chicken)
  end

  test "ingredient_amounts returns ingredients needed by purchased recipe quantity" do
    #recipe serves 2, we want 4, so just 2x
    assert @purchased_recipe.quantity == 4
    assert @purchased_recipe.recipe.output_qty == 2

    amounts = [
      IngredientAmount.mk(1, 1.5),
      IngredientAmount.mk(1, 2.5),
      IngredientAmount.mk(2, 1.4)
    ]
    Recipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    pr_amounts = @purchased_recipe.ingredient_amounts

    assert pr_amounts[0].serialize == IngredientAmount.mk(1, 3.0).serialize
    assert pr_amounts[1].serialize == IngredientAmount.mk(1, 5.0).serialize
    assert pr_amounts[2].serialize == IngredientAmount.mk(2, 2.8).serialize
  end
end
