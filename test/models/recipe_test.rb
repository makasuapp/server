# typed: strict
# == Schema Information
#
# Table name: recipes
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  output_quantity :decimal(6, 2)    default(1.0), not null
#  unit            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
