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
#  index_recipes_on_organization_id_and_name  (organization_id,name)
#
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "is_valid? is true if all steps used in later ones" do 
    r = recipes(:chicken)
    assert r.is_valid?
  end

  test "is_valid? is true if multiple steps used in one" do 
    r = recipes(:sauce)
    recipe_steps = r.recipe_steps.order("step_type DESC, number ASC")
    assert recipe_steps.first.inputs.recipe_step_typed.empty?
    assert recipe_steps.second.inputs.recipe_step_typed.empty?
    assert recipe_steps.last.inputs.recipe_step_typed.size == 2
    assert r.is_valid?
  end

  test "is_valid? is true if no steps" do 
    @organization = organizations(:test)
    r = Recipe.create!(name: "Test", organization_id: @organization.id)
    assert r.recipe_steps.size == 0
    assert r.is_valid?
  end

  test "is_valid? is true if only one step" do 
    r = recipes(:green_onion)
    assert r.recipe_steps.size == 1
    assert r.is_valid?
  end

  test "is_valid? is false if a step is not used in later one" do 
    r = recipes(:chicken)
    step_input = step_inputs(:chicken_c1)
    #no longer referencing chicken_p2 step
    step_input.update_attributes!(inputable_id: recipe_steps(:chicken_p1).id)
    assert r.is_valid? == false
  end

  test "volume_weight_ratio returns volume_weight_ratio of ingredient if is a recipe with just one input" do
    r = recipes(:green_onion)
    i = ingredients(:green_onion)
    assert i.volume_weight_ratio.present?
    assert r.volume_weight_ratio == i.volume_weight_ratio
  end

  test "ingredient_amounts gets all ingredients used in recipe" do
    r = recipes(:sauce)
    ingredients = r.ingredient_amounts(DateTime.now)
    assert ingredients.count == 3
    assert ingredients.find { |i| i.ingredient_id == ingredients(:salt).id }.quantity == 1
    assert ingredients.find { |i| i.ingredient_id == ingredients(:sesame_paste).id }.quantity == 3
    assert ingredients.find { |i| i.ingredient_id == ingredients(:sesame_oil).id }.quantity == 6
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
    step = recipe_steps(:sauce_p2)
    @g = recipes(:green_onion)
    @s = recipes(:sauce)
    @r = recipes(:chicken)

    #green onion is now a subrecipe of both chicken and sauce
    #0.5 * 10 = 5 tbsp needed for sauce = 30g = 0.3 prep
    StepInput.create!(inputable_id: @g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: step.id, quantity: 10, unit: "tbsp")
  end

  test "ingredient_amounts includes sub-recipes' ingredients" do
    ingredients = @r.ingredient_amounts(DateTime.now)
    assert ingredients.count == 7

    #should be the 1tsp 
    green_onions = ingredients.select { |i| i.ingredient_id == ingredients(:green_onion).id }
    assert green_onions.count == 2
    assert green_onions.find { |i| i.quantity.round == 30 && i.unit == "g" }.present?
    assert green_onions.find { |i| i.quantity == 80 && i.unit == "g" }.present?
  end

  test "step_amounts returns step amounts of recipe and subrecipes" do 
    assert @g.recipe_steps.count == 1
    assert @s.recipe_steps.count == 3
    assert @r.recipe_steps.count == 4

    step_amounts = @r.step_amounts(DateTime.now)
    assert step_amounts.count == 9

    green_onion_step = @g.recipe_steps.first
    green_onion_amounts = step_amounts.select { |x| x.recipe_step_id == green_onion_step.id }
    assert green_onion_amounts.count == 2
    assert green_onion_amounts.find { |i| i.quantity.round(1) == 0.3 }.present?
    assert green_onion_amounts.find { |i| i.quantity == 0.8 }.present?
  end

  test "step_amounts are split for same step if different time" do 
    chicken_p1 = @r.recipe_steps.where(step_type: "prep", number: 1).first
    StepInput.create!(inputable_id: @g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: chicken_p1.id, quantity: 20, unit: "tbsp")

    for_time = DateTime.now
    step_amounts = @r.step_amounts(for_time)

    chicken_time = for_time - chicken_p1.min_before_sec.seconds
    chicken_p1_amount = step_amounts.select { |x| x.recipe_step_id == chicken_p1.id }.first
    assert chicken_p1_amount.min_needed_at.to_i == chicken_time.to_i

    green_onion_step = @g.recipe_steps.first
    green_onion_amounts = step_amounts.select { |x| x.recipe_step_id == green_onion_step.id }
    assert green_onion_amounts.count == 3
    assert green_onion_amounts.find { |i| i.quantity.round(1) == 0.3 }.min_needed_at.to_i == for_time.to_i
    assert green_onion_amounts.find { |i| i.quantity.round(2) == 1.2 }.min_needed_at.to_i == chicken_time.to_i
  end

  test "all_in returns the recipes and their subrecipes" do
    new_r = Recipe.create!(name: "New", organization_id: @organization.id)
    not_found = Recipe.create!(name: "Not Found", organization_id: @organization.id)

    recipes = Recipe.all_in([@r.id, new_r.id])
    assert recipes.count == 4
    assert recipes.find { |r| r.id == @r.id }.present?
    assert recipes.find { |r| r.id == @g.id }.present?
    assert recipes.find { |r| r.id == @s.id }.present?
    assert recipes.find { |r| r.id == new_r.id }.present?
    assert recipes.find { |r| r.id == not_found.id }.nil?
  end
end
