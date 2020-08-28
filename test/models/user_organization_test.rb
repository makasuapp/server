# typed: strict
# == Schema Information
#
# Table name: user_organizations
#
#  id              :bigint           not null, primary key
#  role            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  kitchen_id      :bigint
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  organizations_users_idx  (organization_id,user_id)
#  users_organizations_idx  (user_id,organization_id)
#
require 'test_helper'

class UserOrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
