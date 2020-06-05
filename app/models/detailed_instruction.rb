# typed: strict
# == Schema Information
#
# Table name: detailed_instructions
#
#  id          :bigint           not null, primary key
#  instruction :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DetailedInstruction < ApplicationRecord
  extend T::Sig

  has_and_belongs_to_many :recipe_steps
end
