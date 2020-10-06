# typed: false
require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @r = recipes(:green_onion)
    @kitchen = kitchens(:test)
  end

  test "create makes new recipe + steps/inputs" do
    ingredient = ingredients(:green_onion)

    post "/api/recipes", params: { 
      kitchen_id: @kitchen.id,
      recipe: {
        current_price_cents: 1000,
        name: "Test Recipe",
        output_qty: 20,
        publish: true,
        unit: "g",
        step_ids: {
          "0": 1,
          "1": 2
        },
        recipe_steps: {
          "0": {
            instruction: "Test instruction 1",
            number: 1,
            min_before_sec: 100,
            tools: {
              "0": {
                name: "Shouldn't impact it"
              }
            },
            inputs: {
              "0": {
                name: "Shouldn't show up",
                inputable_type: StepInputType::Ingredient,
                inputable_id: ingredient.id,
                quantity: 10,
                unit: "g"
              }
            }
          },
          "1": {
            instruction: "Test instruction 2",
            number: 2,
            inputs: {
              "0": {
                inputable_type: StepInputType::Recipe,
                inputable_id: @r.id,
                quantity: 12,
                unit: "g"
              }
            }
          }
        }
      }
    }, as: :json

    assert_response 200

    r = Recipe.find_by_name("Test Recipe")
    assert r.organization_id == @kitchen.organization_id
    assert r.current_price_cents == 1000
    assert r.publish == true
    assert r.output_qty == 20
    assert r.unit == "g"

    steps = r.recipe_steps.order("number ASC")
    assert steps.latest.count == 2
    assert steps.first.instruction == "Test instruction 1"
    assert steps.last.number == 2

    first_input = steps.first.inputs.first
    assert first_input.inputable_type == StepInputType::Ingredient
    assert first_input.quantity == 10
    assert first_input.unit == "g"

    last_input = steps.last.inputs.first
    assert last_input.inputable_type == StepInputType::Recipe
    assert last_input.quantity == 12
  end

  test "update modifies the recipe + steps/inputs" do
    step = @r.recipe_steps.latest.first
    input = step.inputs.latest.first

    put "/api/recipes/#{@r.id}", params: { 
      kitchen_id: @kitchen.id,
      recipe: {
        name: "Changed name",
        output_qty: @r.output_qty,
        unit: @r.unit,
        recipe_steps: {
          "0": {
            id: step.id,
            inputs: {
              "0": {
                id: input.id,
                quantity: 12,
                unit: "g"
              }
            }
          }
        }
      }
    }, as: :json

    assert_response 200

    assert !step.reload.removed
    assert @r.reload.name == "Changed name"
    assert input.reload.removed

    new_input = step.inputs.latest.first
    assert new_input.id != input.id
    assert new_input.quantity == 12
  end
end