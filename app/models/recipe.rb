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

      steps_to_check = recipe.recipe_steps.latest.includes(:inputs)
      steps_to_check.each do |s|
        s.inputs.latest.select { |input| 
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
      steps = self.recipe_steps.latest
      if steps.length == 1
        step = T.must(steps.first)
        inputs = step.inputs.latest
        if inputs.length == 1
          input = T.must(inputs.first)
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
    parent_inserted_date: T.nilable(T.any(DateTime, ActiveSupport::TimeWithZone)),
    recipe_deductions: T::Hash[Integer, T.nilable(InputAmount)],
    recipe_servings: Float
  ).returns([
    T::Array[StepAmount], 
    T::Array[InputAmount],
    T::Hash[Integer, T.nilable(InputAmount)]
  ])}
  #TODO: not great, a lot of db calls because of nesting
  # get steps and ingredients for recipe + subrecipes minus deductions
  def component_amounts(for_date, include_root_steps: false, parent_inserted_date: nil,
    recipe_deductions: {}, recipe_servings: 1.0)
    steps = []
    inputs = []
    already_inserted_date = parent_inserted_date
    curr_recipe_deductions = T.let(recipe_deductions, T::Hash[Integer, T.nilable(InputAmount)])
    num_servings = recipe_servings

    recipe_deduction = curr_recipe_deductions[self.id]
    if recipe_deduction.present?
      num_servings = num_servings - self.servings_produced(recipe_deduction.quantity, recipe_deduction.unit)

      #deducting is enough, don't need to continue
      if num_servings <= 0
        recipe_deduction.quantity = recipe_deduction.quantity - UnitConverter.convert(
          recipe_servings * self.output_qty, self.unit, recipe_deduction.unit, self.volume_weight_ratio)
        curr_recipe_deductions[self.id] = recipe_deduction

        return [steps, inputs, curr_recipe_deductions]
      #deducted everything from deductions
      else
        curr_recipe_deductions[self.id] = nil
      end
    end

    steps_to_check = self.recipe_steps.latest.includes(:inputs).order("number ASC")
    steps_to_check.each do |step|
      step_needed_at = step.min_needed_at(for_date)

      if include_root_steps
        steps << StepAmount.mk(step.id, step_needed_at, 1 * num_servings)
      end

      latest_date = already_inserted_date || for_date
      #recipe's inputs/prep will show up on an earlier day, so on latest date we'll need as input the made recipe
      #TODO: assumes all steps of a recipe will happen on the same day. will need to enforce this or change this logic
      if latest_date.beginning_of_day.to_i > step_needed_at.beginning_of_day.to_i
        already_inserted_date = step_needed_at
        inputs << InputAmount.mk(self.id, DayInputType::Recipe, 
          latest_date, self.output_qty * num_servings, self.unit)
      end

      step.inputs.latest.each do |input|
        if input.inputable_type == StepInputType::Recipe

          child_recipe = input.inputable
          num_child_servings = child_recipe.servings_produced(input.quantity, input.unit)

          #children needed at is relative to this step's needed at
          #we always want children's steps
          child_steps, child_inputs, child_recipe_deductions = child_recipe.component_amounts(step_needed_at, 
            include_root_steps: true, parent_inserted_date: already_inserted_date, 
            recipe_deductions: curr_recipe_deductions, 
            recipe_servings: num_servings * num_child_servings)

          steps = steps + child_steps
          inputs = inputs + child_inputs
          curr_recipe_deductions = child_recipe_deductions
        end

        if input.inputable_type == StepInputType::Ingredient
          inputs << InputAmount.mk(input.inputable_id, DayInputType::Ingredient, 
            step_needed_at, input.quantity * num_servings, input.unit)
        end
      end
    end

    [steps, inputs, curr_recipe_deductions]
  end

  sig {params(usage_qty: T.any(Float, Integer, BigDecimal), usage_unit: T.nilable(String)).returns(Float)}
  def servings_produced(usage_qty, usage_unit = nil)
    converted_qty = UnitConverter.convert(usage_qty, usage_unit, self.unit, self.volume_weight_ratio)
    converted_qty / self.output_qty
  end

  sig {params(checking_recipe_id: Integer).returns(T::Boolean)}
  #TODO: not great, a lot of db calls because of nesting
  #TODO: check that day jumps in min/max are in separate subrecipe... how decide what fits this?
  #check later steps have less min/max than earlier ones
  #check no subrecipes can use this recipe as input
  #check if children recipes' usages match in units
  def is_valid?(checking_recipe_id = self.id)
    steps_to_check = self.recipe_steps.latest.order("number ASC")
    prev_min_sec = steps_to_check.first.try(:min_before_sec)
    prev_max_sec = steps_to_check.first.try(:max_before_sec)

    steps_to_check.each do |step|
      if prev_min_sec == nil && step.min_before_sec != nil ||
        prev_min_sec != nil && step.min_before_sec != nil && T.must(step.min_before_sec) > prev_min_sec ||
        prev_max_sec == nil && step.max_before_sec != nil ||
        prev_max_sec != nil && step.max_before_sec != nil && T.must(step.max_before_sec) > prev_max_sec ||
        step.min_before_sec != nil && step.max_before_sec != nil && T.must(step.max_before_sec) > T.must(step.min_before_sec)
        puts "step #{step.id} has invalid min/max"
        return false
      end
      prev_min_sec = step.min_before_sec
      prev_max_sec = step.max_before_sec

      step.inputs.latest.recipe_typed.each do |recipe_input|
        child_recipe = recipe_input.inputable

        if child_recipe.id == checking_recipe_id
          puts "child recipe #{child_recipe.id} is same as recipe, causing loop"
          return false
        end

        unless child_recipe.is_valid?(checking_recipe_id)
          puts "child recipe #{child_recipe.id} is invalid"
          return false
        end

        if !UnitConverter.can_convert?(recipe_input.unit, child_recipe.unit, child_recipe.volume_weight_ratio)
          puts "#{child_recipe.name} in #{self.name} can't convert #{recipe_input.unit} to #{child_recipe.unit}"
          return false
        end
      end
    end

    true
  end

  sig {params(recipe_step_params: T.any(
      T::Hash[String, T::Hash[Symbol, T.untyped]],
      ActionController::Parameters
    ),
    init_need_snapshot: T::Boolean).void}
  def update_components(recipe_step_params, init_need_snapshot = false)
    touched_steps = []
    need_snapshot = T.let(init_need_snapshot, T::Boolean)

    recipe_step_params.each do |idx, recipe_step_param|
      if recipe_step_param[:id].present?
        curr_step = RecipeStep.find(recipe_step_param[:id])

        updated_step = curr_step.update_step(recipe_step_param)
        if updated_step.id != curr_step.id
          touched_steps << curr_step.id
          need_snapshot = true
          curr_step = updated_step
        end
      else
        base_recipe_step_param = recipe_step_param.clone
        base_recipe_step_param[:inputs] = []
        curr_step = self.recipe_steps.create!(base_recipe_step_param)
        need_snapshot = true
      end
      touched_steps << curr_step.id

      touched_inputs = []
      if recipe_step_params[:inputs].present?
        recipe_step_param[:inputs].each do |i, input_param|
          if input_param[:id].present?
            curr_input = StepInput.find(input_param[:id])

            updated_input = curr_input.update_input(input_param)
            if updated_input.id != curr_input.id
              touched_inputs << curr_input.id
              need_snapshot = true
              curr_input = updated_input
            end
          else
            curr_input = StepInput.new(input_param)
            need_snapshot = true
          end

          curr_input.recipe_step_id = curr_step.id
          curr_input.save!

          touched_inputs << curr_input.id
        end
      end

      to_remove_inputs = curr_step.inputs.latest.where.not(id: touched_inputs)
      to_remove_inputs.each do |input|
        need_snapshot = true
        input.delete_input
      end
    end

    to_remove_steps = self.recipe_steps.latest.where.not(id: touched_steps)
    to_remove_steps.each do |step|
      need_snapshot = true
      step.delete_step
    end

    unless self.is_valid?
      #TODO: revert recipe to previous snapshot?
      raise "Updates to recipe #{self.id} are not valid"
    end

    if need_snapshot
      RecipeSnapshot.create_for!(self)
    end
  end

  private
  sig {void}
  def update_price
    if self.current_price_cents.present?
      self.item_prices.create!(price_cents: T.must(self.current_price_cents))
    end
  end
end
