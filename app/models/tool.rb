# typed: strict
# == Schema Information
#
# Table name: tools
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tool < ApplicationRecord
  extend T::Sig
  
  has_and_belongs_to_many :recipe_steps
end
