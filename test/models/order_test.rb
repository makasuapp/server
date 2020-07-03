# typed: strict
# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  aasm_state  :string           not null
#  for_time    :datetime
#  order_type  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
