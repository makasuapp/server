# typed: strict
# == Schema Information
#
# Table name: procurement_items
#
#  id                   :bigint           not null, primary key
#  got_qty              :float
#  got_unit             :string
#  price_cents          :integer
#  price_unit           :string
#  quantity             :float            not null
#  unit                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ingredient_id        :bigint           not null
#  procurement_order_id :bigint           not null
#
# Indexes
#
#  index_procurement_items_on_ingredient_id         (ingredient_id)
#  index_procurement_items_on_procurement_order_id  (procurement_order_id)
#
class ProcurementItem < ApplicationRecord
  extend T::Sig

  belongs_to :ingredient
  belongs_to :procurement_order
end
