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
class ProcurementOrder < ApplicationRecord
  extend T::Sig

  validates :order_type, inclusion: { in: %w(manual delivery), message: "%{value} is not a valid type" }
  belongs_to :vendor
  belongs_to :kitchen
  has_many :procurement_items
end
