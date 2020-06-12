# typed: strict
# == Schema Information
#
# Table name: op_days
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_op_days_on_date  (date)
#
require 'test_helper'

class OpDayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
