require 'test_helper'

class StepInputTest < ActiveSupport::TestCase
  setup do
    @input = step_inputs(:green_onion_p1)
  end

  test "create step input with empty unit has nil unit" do
    input = StepInput.new
    input.inputable_type = StepInputType::Ingredient
    input.quantity = 5
    input.unit = ""
    input.inputable_id = @input.inputable_id
    input.recipe_step_id = @input.recipe_step_id

    input.save!

    assert input.unit == nil
  end

  test "update step input with empty unit has nil unit" do
    @input.update_attributes!(unit: "")

    assert @input.reload.unit == nil
  end
end
