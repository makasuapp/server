# typed: strict
# == Schema Information
#
# Table name: recipes
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  output_quantity :decimal(6, 2)    default(1.0), not null
#  publish         :boolean          default(FALSE), not null
#  unit            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Recipe < ApplicationRecord
  extend T::Sig

  has_many :recipe_steps
  #places where this is an input
  has_many :step_inputs, as: :inputable

  sig {returns(Recipe::ActiveRecord_Relation)}
  def self.published
    self.where(publish: true)
  end

  sig {returns(RecipeStep::ActiveRecord_AssociationRelation)}
  def prep_steps
    self.recipe_steps
      .includes([:tools, :detailed_instructions, {inputs: :inputable}])
      .where(step_type: StepType::Prep)
      .order("number ASC")
  end

  sig {returns(RecipeStep::ActiveRecord_AssociationRelation)}
  def cook_steps
    self.recipe_steps
      .includes([:tools, :detailed_instructions, {inputs: :inputable}])
      .where(step_type: StepType::Cook)
      .order("number ASC")
  end

  # sig {returns(T::Array[StepInput])}
  # #TODO: not great, a lot of db calls
  # def ingredient_inputs
  #   steps_to_check = self.recipe_steps.order("step_type DESC, number ASC")
  #   steps_to_check.each do |step|
  #     step.inputs.where(inputable_type: InputType::Ingredient)
  #   end
  # end

  sig {returns(T::Boolean)}
  #TODO: not great, a lot of db calls
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

      step.inputs.where(inputable_type: InputType::RecipeStep).each do |input|
        used_steps[step_id.call(input.inputable)] = true
      end
    end

    used_steps.values.inject(true) { |sum, step| sum && step }
  end
end
