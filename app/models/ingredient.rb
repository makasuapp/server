# typed: strict
# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ingredient < ApplicationRecord
  extend T::Sig

  #places where this is an input
  has_many :step_inputs, as: :inputable
  has_many :day_ingredients
end
