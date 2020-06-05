# typed: strict
# == Schema Information
#
# Table name: step_inputs
#
#  id             :bigint           not null, primary key
#  inputable_type :string           not null
#  quantity       :integer          default(1), not null
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inputable_id   :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_step_inputs_on_inputable_type_and_inputable_id  (inputable_type,inputable_id)
#  index_step_inputs_on_recipe_step_id                   (recipe_step_id)
#
require 'test_helper'

class StepInputTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
