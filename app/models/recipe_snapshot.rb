# typed: strict
# == Schema Information
#
# Table name: recipe_snapshots
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  output_qty :float            not null
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_recipe_snapshots_on_recipe_id  (recipe_id)
#
class RecipeSnapshot < ApplicationRecord
  extend T::Sig
  
  belongs_to :recipe
  has_and_belongs_to_many :recipe_steps
  has_and_belongs_to_many :step_inputs
end
