# typed: strict
# == Schema Information
#
# Table name: procurement_items
#
#  id                   :bigint           not null, primary key
#  got_qty              :float
#  got_unit             :string
#  latest_price         :boolean          default(TRUE), not null
#  price_cents          :integer
#  quantity             :float            not null
#  unit                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ingredient_id        :bigint           not null
#  procurement_order_id :bigint
#
# Indexes
#
#  index_procurement_items_on_procurement_order_id  (procurement_order_id)
#  procurement_items_latest_idx                     (ingredient_id,latest_price,price_cents)
#
class ProcurementItem < ApplicationRecord
  extend T::Sig

  belongs_to :ingredient
  belongs_to :procurement_order, optional: true
end
