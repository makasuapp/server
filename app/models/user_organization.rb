# typed: strict
# == Schema Information
#
# Table name: user_organizations
#
#  id              :bigint           not null, primary key
#  access_link     :string
#  auth_token      :string
#  role            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  kitchen_id      :bigint
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_user_organizations_on_auth_token  (auth_token) UNIQUE
#  organizations_users_idx                 (organization_id,user_id)
#  users_organizations_idx                 (user_id,organization_id)
#
module UserRole
  User = "user"
  Owner = "owner"
end

class UserOrganization < ApplicationRecord
  extend T::Sig
  
  validates :role, inclusion: { in: %w(user owner), message: "%{value} is not a valid type" }

  belongs_to :organization
  belongs_to :user
  belongs_to :kitchen, optional: true
end
