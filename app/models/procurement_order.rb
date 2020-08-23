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

  sig {params(
    day_ingredients: T.any(
      DayIngredient::ActiveRecord_Relation, 
      DayIngredient::ActiveRecord_AssociationRelation,
      T::Array[DayIngredient]), 
    vendor: Vendor, date: T.any(DateTime, ActiveSupport::TimeWithZone),
    kitchen: Kitchen).void}
  def self.create_from(day_ingredients, vendor, date, kitchen)
    po = ProcurementOrder
    po = ProcurementOrder.create!(
      for_date: date, 
      order_type: "manual",
      kitchen_id: kitchen.id,
      vendor_id: vendor.id
    )
    day_ingredients.each do |di|
      po.procurement_items.create!(
        ingredient_id: di.ingredient_id, 
        quantity: di.expected_qty,
        unit: di.unit
      )
    end
  end
end
