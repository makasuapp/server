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

  test "ingredient_amounts returns recipes' ingredient_amounts * quantity" do
    amounts = [
      IngredientAmount.mk(1, 1.5),
      IngredientAmount.mk(1, 2.5),
      IngredientAmount.mk(2, 1.4)
    ]
    Recipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)

    pr_amounts = @purchased_recipe.ingredient_amounts
    assert @purchased_recipe.quantity == 4

    assert pr_amounts[0].serialize == IngredientAmount.mk(1, 6.0).serialize
    assert pr_amounts[1].serialize == IngredientAmount.mk(1, 10.0).serialize
    assert pr_amounts[2].serialize == IngredientAmount.mk(2, 5.6).serialize
  end
end
