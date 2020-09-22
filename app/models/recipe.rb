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
#  organization_id            :bigint           not null
#
# Indexes
#
#  index_recipes_on_organization_id_and_name     (organization_id,name)
#  index_recipes_on_organization_id_and_publish  (organization_id,publish)
#
class Recipe < ApplicationRecord
  extend T::Sig

  has_many :recipe_steps, dependent: :destroy
  #places where this is an input
  has_many :step_inputs, as: :inputable
  has_many :order_items, dependent: :destroy
  has_many :item_prices, dependent: :destroy
  has_many :predicted_orders
  belongs_to :organization

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
          input.inputable_type == StepInputType::Recipe
        }.each do |recipe_input|
          child_recipes = Recipe.all_in([recipe_input.inputable_id])
          recipes = recipes + child_recipes
        end
      end
    end

    recipes.uniq
  end

  sig {returns(T.nilable(Float))}
  def volume_weight_ratio
    if self.output_volume_weight_ratio.nil?
      if self.recipe_steps.length == 1
        step = T.must(self.recipe_steps.first)
        if step.inputs.length == 1
          input = T.must(step.inputs.first)
          if input.inputable_type == StepInputType::Ingredient
            return input.inputable.volume_weight_ratio
          end
        end
      end
    end

    self.output_volume_weight_ratio
  end

  sig {params(
    for_date: T.any(DateTime, ActiveSupport::TimeWithZone),
    include_root_steps: T::Boolean,
    parent_inserted_date: T.nilable(T.any(DateTime, ActiveSupport::TimeWithZone))
  ).returns([T::Array[StepAmount], T::Array[InputAmount]])}
  #TODO: not great, a lot of db calls because of nesting
  # get steps and ingredients for recipe + subrecipes
  def component_amounts(for_date, include_root_steps = false, parent_inserted_date = nil)
    steps = []
    inputs = []
    already_inserted_date = parent_inserted_date

    steps_to_check = self.recipe_steps.includes(:inputs).order("number ASC")
    steps_to_check.each do |step|
      step_needed_at = step.min_needed_at(for_date)

      if include_root_steps
        steps << StepAmount.mk(step.id, step_needed_at, 1)
      end

      latest_date = already_inserted_date || for_date
      #recipe's inputs/prep will show up on an earlier day, so on latest date we'll need as input the made recipe
      #TODO: assumes all steps of a recipe will happen on the same day. will need to enforce this or change this logic
      if latest_date.beginning_of_day.to_i > step_needed_at.beginning_of_day.to_i
        already_inserted_date = step_needed_at
        inputs << InputAmount.mk(self.id, DayInputType::Recipe, 
          latest_date, self.output_qty, self.unit)
      end

      step.inputs.each do |input|
        if input.inputable_type == StepInputType::Recipe

          child_recipe = input.inputable
          #children needed at is relative to this step's needed at
          #we always want children's steps
          child_steps, child_inputs = child_recipe.component_amounts(step_needed_at, 
            true, already_inserted_date)

          num_servings = child_recipe.servings_produced(input.quantity, input.unit)
          child_steps.each { |x| steps << x * num_servings }
          child_inputs.each { |x| inputs << x * num_servings }
        end

        if input.inputable_type == StepInputType::Ingredient
          inputs << InputAmount.mk(input.inputable_id, DayInputType::Ingredient, 
            step_needed_at, input.quantity, input.unit)
        end
      end
    end

    [steps, inputs]
  end

  sig {params(usage_qty: T.any(Float, Integer, BigDecimal), usage_unit: T.nilable(String)).returns(Float)}
  def servings_produced(usage_qty, usage_unit = nil)
    converted_qty = UnitConverter.convert(usage_qty, usage_unit, self.unit, self.volume_weight_ratio)
    converted_qty / self.output_qty
  end

  sig {returns(T::Boolean)}
  #TODO: not great, a lot of db calls because of nesting
  #TODO: check if recipe steps min/max times make sense -- later steps should have less min/max than earlier ones
  #TODO: check that day jumps in min/max are in separate subrecipe... how decide what fits this?
  #check if all steps aside from last are inputs to later steps
  #check if children recipes' usages match in units
  def is_valid?
    steps_to_check = self.recipe_steps.order("number ASC")
    used_steps = {}
    mk_step_id = ->(step) {"#{step.recipe_id}#{step.number}"}
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
