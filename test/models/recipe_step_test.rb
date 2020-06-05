# typed: strict
# == Schema Information
#
# Table name: recipe_steps
#
#  id             :bigint           not null, primary key
#  duration_sec   :integer
#  instruction    :text             not null
#  max_before_sec :integer
#  min_before_sec :integer
#  number         :integer          not null
#  step_type      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipe_id      :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id  (recipe_id)
#  index_recipe_steps_on_step_type  (step_type)
#
require 'test_helper'

class RecipeStepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
