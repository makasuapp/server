# typed: strict
# == Schema Information
#
# Table name: vendors
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_vendors_on_organization_id  (organization_id)
#
class Vendor < ApplicationRecord
  extend T::Sig

  belongs_to :organization
end
