# typed: strict
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
class DayIngredient < ApplicationRecord
  extend T::Sig

  belongs_to :ingredient
  belongs_to :op_day
end
