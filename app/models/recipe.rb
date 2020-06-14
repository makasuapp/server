# typed: strict
# == Schema Information
#
# Table name: recipes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  output_qty :float            default(1.0), not null
#  publish    :boolean          default(FALSE), not null
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
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

  sig {returns(T::Array[IngredientAmount])}
  #TODO: not great, a lot of db calls
  def ingredient_amounts
    amounts = []
    steps_to_check = self.recipe_steps.order("step_type DESC, number ASC")
    steps_to_check.each do |step|
      amounts = amounts + step.inputs.ingredient_typed.map { |input| 
        IngredientAmount.mk(input.inputable_id, input.quantity, input.unit)
      }

      step.inputs.recipe_typed.each do |recipe_input|
        child_recipe = recipe_input.inputable
        num_servings = child_recipe.servings_produced(recipe_input.quantity, recipe_input.unit)
        child_recipe.ingredient_amounts.each do |amount|
          amounts << amount * num_servings
        end
      end
    end

    amounts
  end

  sig {params(usage_qty: T.any(Float, Integer, BigDecimal), usage_unit: T.nilable(String)).returns(Float)}
  def servings_produced(usage_qty, usage_unit = nil)
    converted_qty = UnitConverter.convert(usage_qty, usage_unit, self.unit)
    converted_qty / self.output_qty
  end

  sig {returns(T::Boolean)}
  #TODO: not great, a lot of db calls
  #check if all steps aside from last are inputs to later steps
  #check if children recipes' usages match in units
  def is_valid?
    steps_to_check = self.recipe_steps.order("step_type DESC, number ASC")
    used_steps = {}
    mk_step_id = ->(step) {"#{step.step_type}#{step.number}"}
    last_id = steps_to_check.last.try(:id)

    steps_to_check.each do |step|
      if step.id != last_id && used_steps[mk_step_id.call(step)].nil?
        used_steps[mk_step_id.call(step)] = false
      end

      step.inputs.recipe_step_typed.each do |input|
        used_steps[mk_step_id.call(input.inputable)] = true
      end

      step.inputs.recipe_typed.each do |recipe_input|
        child_recipe = recipe_input.inputable
        if !UnitConverter.unit_matches?(recipe_input.unit, child_recipe.unit)
          puts "#{child_recipe.name} in #{self.name} is invalid"
          return false
        end
      end
    end

    used_steps.values.inject(true) { |sum, step| sum && step }
  end
end
