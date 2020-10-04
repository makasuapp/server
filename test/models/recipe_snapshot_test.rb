# == Schema Information
#
# Table name: recipe_snapshots
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  output_qty :float            not null
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_recipe_snapshots_on_recipe_id  (recipe_id)
#
require 'test_helper'

class RecipeSnapshotTest < ActiveSupport::TestCase
  setup do
    @recipe = recipes(:green_onion)
  end

  test "create_for! creates snapshot of latest recipe" do
    assert @recipe.recipe_steps.count == 2
    assert @recipe.recipe_steps.latest.count == 1

    snapshot = RecipeSnapshot.create_for!(@recipe)
    assert snapshot.name == @recipe.name
    assert snapshot.unit == @recipe.unit
    assert snapshot.output_qty == @recipe.output_qty
    assert snapshot.recipe_steps.count == 1
    assert snapshot.step_inputs.count == 1

    recipe_step = recipe_steps(:green_onion_p1)
    assert snapshot.recipe_steps.first.id == recipe_step.id
  end
end
