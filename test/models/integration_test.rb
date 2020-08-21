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
#  index_integrations_on_kitchen_id  (kitchen_id)
#
require 'test_helper'

class IntegrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
