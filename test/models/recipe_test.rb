# typed: false
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
require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "is_valid? is true if all steps used in later ones" do 
    r = recipes(:chicken)
    assert r.is_valid?
  end

  test "is_valid? is true if multiple steps used in one" do 
    r = recipes(:sauce)
    recipe_steps = r.recipe_steps.order("number ASC")
    assert recipe_steps.first.inputs.recipe_step_inputs.empty?
    assert recipe_steps.second.inputs.recipe_step_inputs.empty?
    assert recipe_steps.last.inputs.recipe_step_inputs.size == 2
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
end
