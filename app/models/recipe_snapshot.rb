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

  sig {params(recipe: Recipe, 
    recipe_params: T::Hash[Symbol, T.untyped]).returns(T::Boolean)}
  def self.would_differ?(recipe, recipe_params)
    recipe.name != recipe_params[:name] ||
      recipe.output_qty != recipe_params[:output_qty] ||
      recipe.unit != recipe_params[:unit]
  end

  sig {params(recipe: Recipe).returns(RecipeSnapshot)}
  def self.create_for!(recipe)
    snapshot = RecipeSnapshot.create!(
      name: recipe.name,
      output_qty: recipe.output_qty,
      unit: recipe.unit,
      recipe_id: recipe.id
    )

    recipe.recipe_steps.latest.includes(:inputs).each do |step|
      snapshot.recipe_steps << step
      step.inputs.latest.each do |input|
        snapshot.step_inputs << input
      end
    end

    snapshot
  end
end
