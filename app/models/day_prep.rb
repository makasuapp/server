# typed: strict
# == Schema Information
#
# Table name: day_preps
#
#  id             :bigint           not null, primary key
#  expected_qty   :float            not null
#  made_qty       :float
#  min_needed_at  :datetime
#  qty_updated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kitchen_id     :bigint
#  op_day_id      :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_day_preps_on_kitchen_id_and_min_needed_at  (kitchen_id,min_needed_at)
#  index_day_preps_on_op_day_id                     (op_day_id)
#  index_day_preps_on_recipe_step_id                (recipe_step_id)
#
class DayPrep < ApplicationRecord
  extend T::Sig

  belongs_to :recipe_step
  belongs_to :op_day
end
