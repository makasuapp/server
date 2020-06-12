# typed: strict
# == Schema Information
#
# Table name: day_ingredients
#
#  id            :bigint           not null, primary key
#  expected_qty  :integer
#  had_qty       :integer
#  unit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :bigint
#  op_day_id     :bigint
#
# Indexes
#
#  index_day_ingredients_on_ingredient_id  (ingredient_id)
#  index_day_ingredients_on_op_day_id      (op_day_id)
#
require 'test_helper'

class DayIngredientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
