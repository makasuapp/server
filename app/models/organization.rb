# typed: strict
# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Organization < ApplicationRecord
  extend T::Sig

  has_many :user_organizations
  has_many :recipes
  has_many :kitchens
end
