# typed: strict
# == Schema Information
#
# Table name: step_inputs
#
#  id             :bigint           not null, primary key
#  inputable_type :string           not null
#  quantity       :float            default(1.0), not null
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inputable_id   :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_step_inputs_on_inputable_type_and_inputable_id  (inputable_type,inputable_id)
#  index_step_inputs_on_recipe_step_id                   (recipe_step_id)
#
class StepInput < ApplicationRecord
  extend T::Sig

  validates :inputable_type, inclusion: { in: %w(Recipe Ingredient RecipeStep), message: "%{value} is not a valid type" }
  validate :recipe_input_not_recursive, :step_input_above_chain

  belongs_to :recipe_step
  belongs_to :inputable, polymorphic: true

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def self.recipe_typed
    self.where(inputable_type: StepInputType::Recipe)
  end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def self.recipe_step_typed
    self.where(inputable_type: StepInputType::RecipeStep)
  end

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def self.ingredient_typed
    self.where(inputable_type: StepInputType::Ingredient)
  end

  sig {void}
  def step_input_above_chain
    if self.inputable_type == StepInputType::RecipeStep
      input_step = RecipeStep.find(self.inputable_id) 
      of_step = self.recipe_step

      if input_step.recipe_id != of_step.recipe_id
        errors.add(:inputable_type, "must not be a step from a different recipe")
      end

      if (input_step.number > of_step.number)
        errors.add(:inputable_type, "must not be a step after this one")
      end
    end
  end

  sig {void}
  def recipe_input_not_recursive
    if self.inputable_type == StepInputType::Recipe && self.id.present?
      input_recipe = Recipe.find(self.inputable_id)
      of_recipe_id = self.recipe_step.recipe_id
      # TODO: check that inputs to of_recipe that are recipes don't use input_recipe to make. need to recurse
      # errors.add(:inputable_type, "must not be a recipe using this step")
    end
  end

  sig {returns(String)}
  def name
    self.inputable.name
  end
end
