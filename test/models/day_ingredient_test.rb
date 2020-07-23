# typed: false
# == Schema Information
#
# Table name: day_ingredients
#
#  id             :bigint           not null, primary key
#  expected_qty   :float            not null
#  had_qty        :float
#  qty_updated_at :datetime
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  ingredient_id  :bigint           not null
#  op_day_id      :bigint           not null
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
    @i1 = ingredients(:salt)
    @i2 = ingredients(:green_onion)
  end

  test "generate_for creates DayIngredients for the purchased recipes' amount of ingredients" do
    count = DayIngredient.count
    assert PurchasedRecipe.count == 1

    amounts = [
      IngredientAmount.mk(@i1.id, 1.5),
      IngredientAmount.mk(@i2.id, 1.4)
    ]
    PurchasedRecipe.any_instance.expects(:ingredient_amounts).once.returns(amounts)
    DayIngredient.generate_for(PurchasedRecipe.all, @today)

    assert DayIngredient.count == count + 2
    assert DayIngredient.where(ingredient_id: @i1.id).first.expected_qty == 1.5
    assert DayIngredient.where(ingredient_id: @i2.id).first.expected_qty == 1.4
  end

  test "generate_for aggregates the ingredients" do
    new_pr = @purchased_recipe.dup
    new_pr.save!
    count = DayIngredient.count
    assert PurchasedRecipe.count == 2

    amounts = [
      IngredientAmount.mk(@i1.id, 1.5),
      IngredientAmount.mk(@i1.id, 1.3),
      IngredientAmount.mk(@i2.id, 1.4, "kg"),
      IngredientAmount.mk(@i2.id, 1100, "g"),
    ]
    PurchasedRecipe.any_instance.expects(:ingredient_amounts).times(2).returns(amounts)
    DayIngredient.generate_for(PurchasedRecipe.all, @today)

    assert DayIngredient.count == count + 2
    assert DayIngredient.where(ingredient_id: @i1.id).first.expected_qty == 5.6
    second = DayIngredient.where(ingredient_id: @i2.id).first
    assert second.expected_qty == ((1100.0/1000) + 1.4) * 2
    assert second.unit == "kg"
  end
end
