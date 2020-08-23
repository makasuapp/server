# typed: strict
# == Schema Information
#
# Table name: procurement_orders
#
#  id         :bigint           not null, primary key
#  for_date   :datetime         not null
#  order_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint           not null
#  vendor_id  :bigint           not null
#
# Indexes
#
#  index_procurement_orders_on_kitchen_id_and_for_date  (kitchen_id,for_date)
#  index_procurement_orders_on_vendor_id                (vendor_id)
#
require 'test_helper'

class ProcurementOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
