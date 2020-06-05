# typed: strict
# == Schema Information
#
# Table name: detailed_instructions
#
#  id          :bigint           not null, primary key
#  instruction :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class DetailedInstructionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
