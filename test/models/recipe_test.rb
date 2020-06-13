# typed: false 
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
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "is_valid? is true if all steps used in later ones" do 
    r = recipes(:chicken)
    assert r.is_valid?
  end

  test "is_valid? is true if multiple steps used in one" do 
    r = recipes(:sauce)
    recipe_steps = r.recipe_steps.order("number ASC")
    assert recipe_steps.first.inputs.recipe_step_typed.empty?
    assert recipe_steps.second.inputs.recipe_step_typed.empty?
    assert recipe_steps.last.inputs.recipe_step_typed.size == 2
    assert r.is_valid?
  end

  test "is_valid? is true if no steps" do 
    r = Recipe.create!(name: "Test")
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

  test "ingredient_amounts gets all ingredients used in recipe" do
    r = recipes(:sauce)
    ingredients = r.ingredient_amounts
    assert ingredients.count == 3
    assert ingredients.find { |i| i.ingredient_id == ingredients(:salt).id }.quantity == 1
    assert ingredients.find { |i| i.ingredient_id == ingredients(:sesame_paste).id }.quantity == 3
    assert ingredients.find { |i| i.ingredient_id == ingredients(:sesame_oil).id }.quantity == 6
  end

  test "ingredient_amounts includes sub-recipes' ingredients" do
    step = recipe_steps(:sauce_p2)
    subrecipe = recipes(:green_onion)
    #TODO(unit_conversion)
    StepInput.create!(inputable_id: subrecipe.id, inputable_type: InputType::Recipe, 
      recipe_step_id: step.id, quantity: 250, unit: "teaspoons")

    r = recipes(:chicken)
    ingredients = r.ingredient_amounts
    assert ingredients.count == 7

    green_onions = ingredients.select { |i| i.ingredient_id == ingredients(:green_onion).id }
    assert green_onions.count == 2
    assert green_onions.find { |i| i.quantity == 250 }.present?
    assert green_onions.find { |i| i.quantity == 100 }.present?
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
    #TODO(unit_conversion)
    assert r.servings_produced(5, "tablespoons") == 0.05
  end
end
