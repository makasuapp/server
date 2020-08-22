# typed: strict
# == Schema Information
#
# Table name: integrations
#
#  id                  :bigint           not null, primary key
#  integration_type    :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  kitchen_id          :bigint           not null
#  wix_app_instance_id :string
#  wix_restaurant_id   :string
#
# Indexes
#
#  index_integrations_on_integration_type_and_wix_restaurant_id  (integration_type,wix_restaurant_id)
#  index_integrations_on_kitchen_id                              (kitchen_id)
#

module IntegrationType
  Wix = "wix"
end

class Integration < ApplicationRecord
  extend T::Sig

  validates :integration_type, inclusion: { in: %w(wix), message: "%{value} is not a valid type" }

  belongs_to :kitchen
end
