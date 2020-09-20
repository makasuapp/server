# typed: strict
# == Schema Information
#
# Table name: day_inputs
#
#  id             :bigint           not null, primary key
#  expected_qty   :float            not null
#  had_qty        :float
#  inputable_type :string           default("Ingredient"), not null
#  min_needed_at  :datetime         not null
#  qty_updated_at :datetime
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inputable_id   :bigint           not null
#  kitchen_id     :bigint           not null
#  op_day_id      :bigint           not null
#
# Indexes
#
#  index_day_inputs_on_inputable_type_and_inputable_id  (inputable_type,inputable_id)
#  index_day_inputs_on_kitchen_id_and_min_needed_at     (kitchen_id,min_needed_at)
#  index_day_inputs_on_op_day_id                        (op_day_id)
#
module DayInputType
  Recipe = "Recipe"
  Ingredient = "Ingredient"
end

class DayInput < ApplicationRecord
  extend T::Sig

  validates :inputable_type, inclusion: { in: %w(Recipe Ingredient), message: "%{value} is not a valid type" }

  belongs_to :inputable, polymorphic: true
  belongs_to :op_day
  belongs_to :kitchen
end
