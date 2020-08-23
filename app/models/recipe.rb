# typed: strict
# == Schema Information
#
# Table name: recipes
#
#  id                         :bigint           not null, primary key
#  current_price_cents        :integer
#  name                       :string           not null
#  output_qty                 :float            default(1.0), not null
#  output_volume_weight_ratio :float
#  publish                    :boolean          default(FALSE), not null
#  unit                       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  kitchen_id                 :bigint           not null
#
# Indexes
#
#  index_recipes_on_kitchen_id_and_name  (kitchen_id,name)
#
class Recipe < ApplicationRecord
  extend T::Sig

  has_many :recipe_steps, dependent: :destroy
  #places where this is an input
  has_many :step_inputs, as: :inputable
  has_many :order_items, dependent: :destroy
  has_many :item_prices, dependent: :destroy
  has_many :predicted_orders
  belongs_to :kitchen

  after_save :update_price, if: :saved_change_to_current_price_cents

  sig {returns(Recipe::ActiveRecord_Relation)}
  def self.published
    self.where(publish: true)
  end

  sig {params(recipe_ids: T::Array[Integer]).returns(T::Array[Recipe])}
  def self.all_in(recipe_ids)
    recipes = []

    Recipe.where(id: recipe_ids).each do |recipe|
      recipes << recipe

      steps_to_check = recipe.recipe_steps.includes(:inputs)
      steps_to_check.each do |s|
        s.inputs.select { |input| 
          input.inputable_type == InputType::Recipe
        }.each do |recipe_input|
          child_recipes = Recipe.all_in([recipe_input.inputable_id])
          recipes = recipes + child_recipes
        end
      end
    end

    recipes.uniq
  end

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def prep_steps
    self.recipe_steps
      .includes([:tools, :detailed_instructions, :inputs])
      .prep
      .order("number ASC")
  end

  sig {returns(T.any(RecipeStep::ActiveRecord_Relation, RecipeStep::ActiveRecord_AssociationRelation))}
  def cook_steps
    self.recipe_steps
      .includes([:tools, :detailed_instructions, :inputs])
      .cook
      .order("number ASC")
  end

  sig {returns(T::Array[StepAmount])}
  #TODO: not great, a lot of db calls
  def step_amounts
    steps = []

    steps_to_check = self.recipe_steps.includes(:inputs).order("step_type DESC, number ASC")
    steps_to_check.each do |s|
      s.inputs.select { |input| 
        input.inputable_type == InputType::Recipe
      }.each do |recipe_input|
        child_recipe = recipe_input.inputable
        child_steps = child_recipe.step_amounts

        num_servings = child_recipe.servings_produced(recipe_input.quantity, recipe_input.unit)
        child_step_amounts = child_steps.map { |x| x * num_servings }
        steps = steps + child_step_amounts
      end

      steps << StepAmount.mk(s.id, 1)
    end

    steps
  end

  sig {returns(T.nilable(Float))}
  def volume_weight_ratio
    if self.output_volume_weight_ratio.nil?
      if self.recipe_steps.length == 1
        step = T.must(self.recipe_steps.first)
        if step.inputs.length == 1
          input = T.must(step.inputs.first)
          if input.inputable_type == InputType::Ingredient
            return input.inputable.volume_weight_ratio
          end
        end
      end
    end

    self.output_volume_weight_ratio
  end

  sig {returns(T::Array[IngredientAmount])}
  #TODO: not great, a lot of db calls
  def ingredient_amounts
    amounts = []
    steps_to_check = self.recipe_steps.includes(:inputs).order("step_type DESC, number ASC")
    steps_to_check.each do |step|
      amounts = amounts + step.inputs.select { |input| 
        input.inputable_type == InputType::Ingredient
      }.map { |input| 
        IngredientAmount.mk(input.inputable_id, input.quantity, input.unit)
      }

      step.inputs.select { |input| 
        input.inputable_type == InputType::Recipe
      }.each do |recipe_input|
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
    converted_qty = UnitConverter.convert(usage_qty, usage_unit, self.unit, self.volume_weight_ratio)
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
        if !UnitConverter.can_convert?(recipe_input.unit, child_recipe.unit, child_recipe.volume_weight_ratio)
          puts "#{child_recipe.name} in #{self.name} can't convert #{recipe_input.unit} to #{child_recipe.unit}"
          return false
        end
      end
    end

    used_steps.values.inject(true) { |sum, step| sum && step }
  end

  private
  sig {void}
  def update_price
    if self.current_price_cents.present?
      self.item_prices.create!(price_cents: T.must(self.current_price_cents))
    end
  end
end
