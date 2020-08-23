# typed: strict
# == Schema Information
#
# Table name: kitchens
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Kitchen < ApplicationRecord
  extend T::Sig

  has_many :integrations
  has_many :recipes
  has_many :predicted_orders
  has_many :op_days
  has_many :orders
  has_many :procurement_orders
end
