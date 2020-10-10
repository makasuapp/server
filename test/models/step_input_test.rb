# == Schema Information
#
# Table name: step_inputs
#
#  id             :bigint           not null, primary key
#  inputable_type :string           not null
#  quantity       :float            default(1.0), not null
#  removed        :boolean          default(FALSE), not null
#  unit           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inputable_id   :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_step_inputs_on_inputable_type_and_inputable_id  (inputable_type,inputable_id)
#  index_step_inputs_on_recipe_step_id_and_removed       (recipe_step_id,removed)
#
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
