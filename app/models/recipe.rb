# typed: strict
# == Schema Information
#
# Table name: recipes
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  output_quantity :decimal(6, 2)    default(1.0), not null
#  unit            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Recipe < ApplicationRecord
  extend T::Sig

  has_many :recipe_steps
  has_many :step_inputs, through: :recipe_steps
  has_many :step_inputs, as: :inputable

  sig {returns(RecipeStep::ActiveRecord_AssociationRelation)}
  def prep_steps
    self.recipe_steps.where(step_type: "prep")
  end

  sig {returns(RecipeStep::ActiveRecord_AssociationRelation)}
  def cook_steps
    self.recipe_steps.where(step_type: "cook")
  end

  sig {returns(T::Boolean)}
  def is_valid?
    #check if all steps aside from last are inputs to later steps
    steps_to_check = self.recipe_steps.order("step_type DESC, number ASC")
    used_steps = {}
    step_id = ->(step) {"#{step.step_type}#{step.number}"}
    last_id = steps_to_check.last.try(:id)

    steps_to_check.each do |step|
      if step.id != last_id && used_steps[step_id.call(step)].nil?
        used_steps[step_id.call(step)] = false
      end

      step.inputs.recipe_step_inputs.each do |input|
        used_steps[step_id.call(input.inputable)] = true
      end
    end

    used_steps.values.inject(true) { |sum, step| sum && step }
  end
end
