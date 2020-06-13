# typed: false

require 'test_helper'

class IngredientAmountTest < ActiveSupport::TestCase
  setup do
    @i1_1 = IngredientAmount.new(ingredient_id: 1, quantity: 1.4)
    @i1_2 = IngredientAmount.new(ingredient_id: 1, quantity: 2.5)
    @i1_3 = IngredientAmount.new(ingredient_id: 1, quantity: 1.5)
    @i2 = IngredientAmount.new(ingredient_id: 2, quantity: 1.5)
  end

  test "sum_by_id aggregates multiple different IngredientAmount" do
    sum = IngredientAmount.sum_by_id([@i1_1, @i1_2, @i2, @i1_3])
    assert sum[0].serialize == IngredientAmount.mk(1, 5.4).serialize
    assert sum[1].serialize == @i2.serialize
  end

  test "* creates IngredientAmount with quantity multiplied" do
    assert (@i1_1 * 2).serialize == IngredientAmount.mk(1, 2.8).serialize
  end

  test "+ adds two IngredientAmount's quantities together" do
    assert (@i1_1 + @i1_2).serialize == IngredientAmount.mk(1, 3.9).serialize
  end

  test "+ errors if adding for two different ingredient" do
    assert_raises RuntimeError do
      @i1_1 + @i2
    end
  end

  test "+ converts unit" do
    #TODO(unit_conversion)
  end
end