# typed: false
# == Schema Information
#
# Table name: day_ingredients
#
#  id            :bigint           not null, primary key
#  expected_qty  :float            not null
#  had_qty       :float
#  unit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :bigint           not null
#  op_day_id     :bigint           not null
#
# Indexes
#
#  index_day_ingredients_on_ingredient_id  (ingredient_id)
#  index_day_ingredients_on_op_day_id      (op_day_id)
#
require 'test_helper'

class DayIngredientTest < ActiveSupport::TestCase
  setup do
    @purchased_recipe = purchased_recipes(:chicken)
    @today = op_days(:today)
  end

  test "generate_for creates DayIngredients for the purchased recipes' amount of ingredients" do
    count = DayIngredient.count
    assert PurchasedRecipe.count == 1

    amounts = [
      IngredientAmount.mk(1, 1.5),
      IngredientAmount.mk(2, 1.4)
    ]
    PurchasedRecipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    DayIngredient.generate_for(PurchasedRecipe.all, @today)

    assert DayIngredient.count == count + 2
    assert DayIngredient.where(ingredient_id: 1).first.expected_qty == 1.5
    assert DayIngredient.where(ingredient_id: 2).first.expected_qty == 1.4
  end

  test "generate_for aggregates the ingredients" do
    new_pr = @purchased_recipe.dup
    new_pr.save!
    count = DayIngredient.count
    assert PurchasedRecipe.count == 2

    amounts = [
      IngredientAmount.mk(1, 1.5),
      IngredientAmount.mk(1, 1.3),
      IngredientAmount.mk(2, 1.4)
    ]
    PurchasedRecipe.any_instance.expects(:ingredient_amounts).times(2).returns(amounts)
    DayIngredient.generate_for(PurchasedRecipe.all, @today)

    assert DayIngredient.count == count + 2
    assert DayIngredient.where(ingredient_id: 1).first.expected_qty == 5.6
  end
end
