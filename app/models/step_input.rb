# typed: strict
# == Schema Information
#
# Table name: step_inputs
#
#  id             :bigint           not null, primary key
#  inputable_type :string           not null
#  quantity       :float            default(1.0), not null
#  removed        :boolean          default(FALSE), not null
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inputable_id   :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_step_inputs_on_inputable_type_and_inputable_id  (inputable_type,inputable_id)
#  index_step_inputs_on_recipe_step_id_and_removed       (recipe_step_id,removed)
#
class StepInput < ApplicationRecord
  extend T::Sig

  validates :inputable_type, inclusion: { in: %w(Recipe Ingredient RecipeStep), message: "%{value} is not a valid type" }
  validate :recipe_input_not_recursive, :step_input_above_chain

  belongs_to :recipe_step
  belongs_to :inputable, polymorphic: true

  before_save :nil_empty_unit, if: :will_save_change_to_unit?

  sig {returns(T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def self.latest
    self.where(removed: false)
  end

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

  sig {params(recipe: Recipe).returns(
    T.any(StepInput::ActiveRecord_Relation, StepInput::ActiveRecord_AssociationRelation))}
  def self.for_recipe(recipe)
    self.joins({recipe_step: :recipe})
      .where("recipes.id = ?", recipe.id)
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

  sig {void}
  def delete_input
    self.update_attributes(removed: true)
  end

  sig {params(params: T.any(
      T::Hash[Symbol, T.untyped],
      ActionController::Parameters
  )).returns(StepInput)}
  def update_input(params)
    input = self

    if self.removed
      raise "Unexpected updating an old input id=#{self.id}"
    end

    if (
      (params[:inputable_id] && params[:inputable_id].to_i != self.inputable_id) ||
      (params[:inputable_type] && params[:inputable_type] != self.inputable_type) ||
      (params[:quantity] && params[:quantity].to_f != self.quantity) || 
      params[:unit] != self.unit 
    )
      input = self.dup
      input.inputable_id = params[:inputable_id] || self.inputable_id
      input.inputable_type = params[:inputable_type] || self.inputable_type
      input.quantity = params[:quantity] || self.quantity
      input.unit = params[:unit]
      input.save!

      self.update_attributes(removed: true)
    end

    input
  end

  private

  sig {void}
  def nil_empty_unit
    if self.unit == ""
      self.unit = nil
    end
  end
end
