# typed: false 
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
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "is_valid? is true if all steps used in later ones" do 
    r = recipes(:chicken)
    assert r.is_valid?
  end

  test "is_valid? is true if multiple steps used in one" do 
    r = recipes(:sauce)
    recipe_steps = r.recipe_steps.latest.order("number ASC")
    assert recipe_steps.first.inputs.latest.recipe_step_typed.empty?
    assert recipe_steps.second.inputs.latest.recipe_step_typed.empty?
    assert recipe_steps.last.inputs.latest.recipe_step_typed.size == 2
    assert r.is_valid?
  end

  test "is_valid? is true if later steps happen later min/max" do
    r = recipes(:prep_chicken)
    assert r.is_valid?
  end

  test "is_valid? is false if later step happens earlier min/max" do
    r = recipes(:prep_chicken)
    recipe_steps = r.recipe_steps.latest.order("number ASC")

    recipe_steps.first.update_attributes(min_before_sec: 0)
    assert !r.is_valid?

    recipe_steps.first.update_attributes(min_before_sec: nil)
    assert !r.is_valid?
  end
  test "is_valid? is false if max is more than min" do
    r = recipes(:sauce)
    recipe_steps = r.recipe_steps.latest.order("number ASC")

    #happen 40-30 min before
    recipe_steps.first.update_attributes(min_before_sec: 30 * 60, max_before_sec: 40 * 60)
    assert !r.is_valid?

    #happen 30-40 min before
    recipe_steps.first.update_attributes(min_before_sec: 40 * 60, max_before_sec: 30 * 60)
    assert r.is_valid?
  end

  test "is_valid? is true if no steps" do 
    @organization = organizations(:test)
    r = Recipe.create!(name: "Test", organization_id: @organization.id)
    assert r.recipe_steps.latest.size == 0
    assert r.is_valid?
  end

  test "is_valid? is true if only one step" do 
    r = recipes(:green_onion)
    assert r.recipe_steps.latest.size == 1
    assert r.is_valid?
  end

  test "is_valid? is false if a step is not used in later one" do 
    r = recipes(:chicken)
    step_input = step_inputs(:chicken_c2_i1)
    step_input.destroy
    assert r.is_valid? == false
  end

  test "volume_weight_ratio returns volume_weight_ratio of ingredient if is a recipe with just one input" do
    r = recipes(:green_onion)
    i = ingredients(:green_onion)
    assert i.volume_weight_ratio.present?
    assert r.volume_weight_ratio == i.volume_weight_ratio
  end

  test "component_amounts gets all ingredients used in recipe" do
    r = recipes(:sauce)
    steps, inputs, deductions = r.component_amounts(DateTime.now)
    assert inputs.count == 3
    assert inputs.find { |i| i.inputable_id == ingredients(:salt).id }.quantity == 1
    assert inputs.find { |i| i.inputable_id == ingredients(:sesame_paste).id }.quantity == 3
    assert inputs.find { |i| i.inputable_id == ingredients(:sesame_oil).id }.quantity == 6
  end

  test "component_amounts gets steps of current recipe if include_root_steps" do
    r = recipes(:sauce)
    steps, inputs, deductions = r.component_amounts(DateTime.now)
    assert steps.count == 0

    steps, inputs, deductions = r.component_amounts(DateTime.now, include_root_steps: true)
    assert steps.count > 0
  end

  test "component_amounts for recipe that's just steps earlier will only have recipe as input day of" do
    r = recipes(:prep_chicken)
    steps, inputs, deductions = r.component_amounts(DateTime.now)
    assert inputs.count == 3

    today = DateTime.now.beginning_of_day.to_i
    today_inputs = inputs.select {|i| i.min_needed_at.to_i >= today }
    assert today_inputs.size == 1
    assert today_inputs.first.inputable_type == DayInputType::Recipe
  end

  test "component_amounts skips if none left after deductions" do
    r = recipes(:green_onion)
    recipe_deductions = {}
    recipe_deductions[r.id] = InputAmount.mk(r.id, DayInputType::Recipe, 
      DateTime.now, 1, 'kg')

    steps, inputs, deductions = r.component_amounts(DateTime.now, 
      recipe_deductions: recipe_deductions, include_root_steps: true)
    assert steps.count == 0
    assert inputs.count == 0

    assert recipe_deductions[r.id].quantity == 0.9
  end

  test "component_amounts returns less from deductions" do
    r = recipes(:green_onion)
    recipe_deductions = {}
    recipe_deductions[r.id] = InputAmount.mk(r.id, DayInputType::Recipe, 
      DateTime.now, 40, 'g')

    steps, inputs, deductions = r.component_amounts(DateTime.now, 
      recipe_deductions: recipe_deductions, include_root_steps: true)
    assert steps.count == 1
    assert inputs.count == 1

    assert steps.first.quantity == 0.6
    assert inputs.first.quantity == 60
    assert inputs.first.unit == 'g'

    assert recipe_deductions[r.id] == nil
  end

  test "servings_produced when using less of recipe" do
    r = recipes(:chicken)
    assert r.servings_produced(4.5) == 2.25
  end

  test "servings_produced when using more of recipe" do
    r = recipes(:chicken)
    assert r.servings_produced(1) == 0.5
  end

  test "servings_produced when using different unit" do
    r = recipes(:green_onion)
    #1tbsp = 6g, so 50*6/100 = 3
    assert r.servings_produced(50, "tbsp").round == 3
  end
end

class SubRecipeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:test)
    @step = recipe_steps(:sauce_p2)
    @g = recipes(:green_onion)
    @s = recipes(:sauce)
    @r = recipes(:chicken)
    @p = recipes(:prep_chicken)

    #green onion is now a subrecipe of both chicken and sauce
    #0.5 * 10 = 5 tbsp needed for sauce = 30g = 0.3 prep
    StepInput.create!(inputable_id: @g.id, inputable_type: StepInputType::Recipe, 
      recipe_step_id: @step.id, quantity: 10, unit: "tbsp")
  end

  test "is_valid? is false if there's a cycle" do
    StepInput.create!(inputable_id: @r.id, inputable_type: StepInputType::Recipe, 
      recipe_step_id: @step.id, quantity: 10, unit: "tbsp")

    assert @r.is_valid? == false
  end

  test "component_amounts includes sub-recipes' ingredients" do
    steps, inputs, deductions = @r.component_amounts(DateTime.now)
    assert inputs.count == 8

    #should be the 1tsp 
    green_onions = inputs.select { |i| i.inputable_id == ingredients(:green_onion).id }
    assert green_onions.count == 2
    assert green_onions.find { |i| i.quantity.round == 30 && i.unit == "g" }.present?
    assert green_onions.find { |i| i.quantity == 80 && i.unit == "g" }.present?
  end

  test "component_amounts returns step amounts subrecipes but not recipes" do 
    assert @g.recipe_steps.latest.count == 1
    assert @s.recipe_steps.latest.count == 3
    assert @r.recipe_steps.latest.count == 2
    assert @p.recipe_steps.latest.count == 2

    step_amounts, inputs = @r.component_amounts(DateTime.now)
    assert step_amounts.count == 7

    recipe_step = @r.recipe_steps.latest.first
    recipe_amounts = step_amounts.select { |x| x.recipe_step_id == recipe_step.id }
    assert recipe_amounts.count == 0

    green_onion_step = @g.recipe_steps.latest.first
    green_onion_amounts = step_amounts.select { |x| x.recipe_step_id == green_onion_step.id }
    assert green_onion_amounts.count == 2
    assert green_onion_amounts.find { |i| i.quantity.round(1) == 0.3 }.present?
    assert green_onion_amounts.find { |i| i.quantity == 0.8 }.present?
  end

  test "component_amounts splits same step if different time" do 
    chicken_p1 = @p.recipe_steps.latest.where(number: 1).first
    StepInput.create!(inputable_id: @g.id, inputable_type: StepInputType::Recipe, 
      recipe_step_id: chicken_p1.id, quantity: 20, unit: "tbsp")

    for_time = DateTime.now
    step_amounts, inputs = @r.component_amounts(for_time)

    chicken_time = for_time - chicken_p1.min_before_sec.seconds
    chicken_p1_amount = step_amounts.select { |x| x.recipe_step_id == chicken_p1.id }.first
    assert chicken_p1_amount.min_needed_at.to_i == chicken_time.to_i

    green_onion_step = @g.recipe_steps.latest.first
    green_onion_amounts = step_amounts.select { |x| x.recipe_step_id == green_onion_step.id }
    assert green_onion_amounts.count == 3
    assert green_onion_amounts.find { |i| i.quantity.round(1) == 0.3 }.min_needed_at.to_i == for_time.to_i
    assert green_onion_amounts.find { |i| i.quantity.round(2) == 1.2 }.min_needed_at.to_i == chicken_time.to_i
  end

  test "component_amounts with a subrecipe days earlier should have the recipe as an input the day it's needed" do
    #recipe needs 1 + 2 prep chickens a day earlier, both recipes should show up as inputs day of since siblings
    StepInput.create!(inputable_id: @p.id, inputable_type: StepInputType::Recipe,
      recipe_step_id: recipe_steps(:chicken_c2).id, quantity: 2)
    
    chicken_p1 = recipe_steps(:chicken_p1)
    #prep chicken needs green onion same day, green onion shouldn't show up since it's a child of prep chicken
    StepInput.create!(inputable_id: @g.id, inputable_type: StepInputType::Recipe,
      recipe_step_id: chicken_p1.id, quantity: 10, unit: "g")

    #prep chicken needs ingredient two days earlier, that recipe should show up same day as prep chicken
    new_recipe = Recipe.create!(name: "Test", organization_id: @r.organization_id, output_qty: 10, unit: "g")
    new_recipe.recipe_steps.latest.create!(instruction: "Test", number: 1, min_before_sec: 49 * 60 * 60)
    StepInput.create!(inputable_id: new_recipe.id, inputable_type: StepInputType::Recipe,
      recipe_step_id: chicken_p1.id, quantity: 20, unit: "g")

    for_time = DateTime.now
    step_amounts, inputs = @r.component_amounts(for_time)

    recipe_inputs = inputs.select { |i| i.inputable_type == DayInputType::Recipe }
    assert recipe_inputs.size == 4

    new_recipe_inputs = recipe_inputs.select { |i| i.inputable_id == new_recipe.id }
    assert new_recipe_inputs.map(&:quantity).sort == [20,40]
    assert new_recipe_inputs[0].min_needed_at.beginning_of_day.to_i == for_time.beginning_of_day.to_i - 1.day

    prep_inputs = recipe_inputs.select { |i| i.inputable_id == @p.id }
    assert prep_inputs.map(&:quantity).sort == [1,2]
    assert prep_inputs[0].min_needed_at.beginning_of_day.to_i == for_time.beginning_of_day.to_i
  end

  test "component_amounts deducting subrecipe skips subrecipe if none left after" do
    recipe_deductions = {}
    recipe_deductions[@g.id] = InputAmount.mk(@g.id, DayInputType::Recipe, 
      DateTime.now, 1, 'kg')

    steps, inputs, deductions = @r.component_amounts(DateTime.now, 
      recipe_deductions: recipe_deductions)
    g_step = recipe_steps(:green_onion_p1)
    assert steps.select { |x| x.recipe_step_id == g_step.id }.empty?
    g_ingredient = ingredients(:green_onion)
    assert inputs.select { |x| x.inputable_id == g_ingredient.id }.empty?

    assert recipe_deductions[@g.id].quantity == 0.89
  end

  test "component_amounts deducting subrecipe returns less of subrecipe" do
    recipe_deductions = {}
    recipe_deductions[@g.id] = InputAmount.mk(@g.id, DayInputType::Recipe, 
      DateTime.now, 30, 'g')
    recipe_deductions[@r.id] = InputAmount.mk(@r.id, DayInputType::Recipe,
      DateTime.now, 1)

    steps, inputs, deductions = @r.component_amounts(DateTime.now, 
      recipe_deductions: recipe_deductions)
  
    #1 chicken order = -1/2 serving of recipe. need .15 + .4 green onion. -.3 = .25
    g_step = recipe_steps(:green_onion_p1)
    g_ingredient = ingredients(:green_onion)
    chicken_ingredient = ingredients(:chicken)

    assert steps.select { |x| x.recipe_step_id == g_step.id }.first.quantity == 0.25
    assert inputs.select { |x| x.inputable_id == g_ingredient.id }.first.quantity == 25
    assert inputs.select { |x| x.inputable_id == chicken_ingredient.id }.first.quantity == 0.5

    assert recipe_deductions[@g.id] == nil
    assert recipe_deductions[@r.id] == nil
  end

  test "component_amounts with multiple servings returns more" do
    recipe_deductions = {}
    recipe_deductions[@r.id] = InputAmount.mk(@r.id, DayInputType::Recipe,
      DateTime.now, 1)

    #-1/2 serving = need 3.5 servings
    steps, inputs, deductions = @r.component_amounts(DateTime.now, recipe_servings: 4.0,
      recipe_deductions: recipe_deductions)

    g_step = recipe_steps(:green_onion_p1)
    g_ingredient = ingredients(:green_onion)
    chicken_ingredient = ingredients(:chicken)

    assert steps.select { |x| x.recipe_step_id == g_step.id }.map { |x| x.quantity.round(2) }.sort == [1.05, 2.8]
    assert inputs.select { |x| x.inputable_id == g_ingredient.id }.map { |x| x.quantity.round(2) }.sort == [105, 280]
    assert inputs.select { |x| x.inputable_id == chicken_ingredient.id }.first.quantity == 3.5
  end

  #TODO: test that it's adding subrecipe as a whole if it's needed day before

  test "all_in returns the recipes and their subrecipes" do
    new_r = Recipe.create!(name: "New", organization_id: @organization.id)
    not_found = Recipe.create!(name: "Not Found", organization_id: @organization.id)

    recipes = Recipe.all_in([@r.id, new_r.id])
    assert recipes.count == 5
    assert recipes.find { |r| r.id == @r.id }.present?
    assert recipes.find { |r| r.id == @g.id }.present?
    assert recipes.find { |r| r.id == @s.id }.present?
    assert recipes.find { |r| r.id == @p.id }.present?
    assert recipes.find { |r| r.id == new_r.id }.present?
    assert recipes.find { |r| r.id == not_found.id }.nil?
  end
end
