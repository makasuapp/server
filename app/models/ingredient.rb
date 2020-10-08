# typed: strict
# == Schema Information
#
# Table name: ingredients
#
#  id                  :bigint           not null, primary key
#  name                :string           not null
#  volume_weight_ratio :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_vendor_id   :bigint           not null
#  organization_id     :bigint           not null
#
# Indexes
#
#  index_ingredients_on_organization_id           (organization_id)
#  index_ingredients_on_organization_id_and_name  (organization_id,name) UNIQUE
#
class Ingredient < ApplicationRecord
  extend T::Sig

  #places where this is an input
  has_many :step_inputs, as: :inputable
  has_many :day_ingredients
  belongs_to :organization
  belongs_to :default_vendor, class_name: "Vendor"
end
