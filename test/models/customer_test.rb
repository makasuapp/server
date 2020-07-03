# typed: strict
# == Schema Information
#
# Table name: customers
#
#  id           :bigint           not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
