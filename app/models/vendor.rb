# typed: strict
# == Schema Information
#
# Table name: vendors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Vendor < ApplicationRecord
  extend T::Sig
end
