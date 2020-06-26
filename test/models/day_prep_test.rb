# == Schema Information
#
# Table name: day_preps
#
#  id             :bigint           not null, primary key
#  expected_qty   :float            not null
#  made_qty       :float
#  qty_updated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  op_day_id      :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_day_preps_on_op_day_id       (op_day_id)
#  index_day_preps_on_recipe_step_id  (recipe_step_id)
#
require 'test_helper'

class DayPrepTest < ActiveSupport::TestCase
  setup do
    @purchased_recipe = purchased_recipes(:chicken)
    @today = op_days(:today)
  end

  test "generate_for creates DayPreps for the purchased recipes' prep steps and all subrecipes' steps" do
    count = DayPrep.count

    DayPrep.generate_for(PurchasedRecipe.all, @today)

    assert DayPrep.count == count + 6
    assert DayPrep.last.expected_qty == 4
  end

  test "generate_for aggregates the steps" do
    count = DayPrep.count

    new_pr = @purchased_recipe.dup
    new_pr.quantity = 3
    new_pr.save!

    DayPrep.generate_for(PurchasedRecipe.all, @today)

    assert DayPrep.count == count + 6
    assert DayPrep.last.expected_qty == 7
  end
end
