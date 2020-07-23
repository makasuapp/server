# typed: false
# == Schema Information
#
# Table name: day_preps
#
#  id             :bigint           not null, primary key
#  expected_qty   :float            not null
#  made_qty       :float
#  qty_updated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  op_day_id      :bigint           not null
#  recipe_step_id :bigint           not null
#
# Indexes
#
#  index_day_preps_on_op_day_id       (op_day_id)
#  index_day_preps_on_recipe_step_id  (recipe_step_id)
#
require 'test_helper'

class DayPrepTest < ActiveSupport::TestCase
  setup do
    @purchased_recipe = purchased_recipes(:chicken)
    @today = op_days(:today)
    @sauce_step = recipe_steps(:sauce_p2)
    @chicken_step = recipe_steps(:chicken_p2)
  end

  test "generate_for creates DayPreps for the purchased recipes' prep steps and all subrecipes' steps" do
    count = DayPrep.count

    DayPrep.generate_for(PurchasedRecipe.all, @today)

    assert DayPrep.count == count + 6
    assert DayPrep.where(recipe_step_id: @sauce_step.id).first.expected_qty == 1
    assert DayPrep.where(recipe_step_id: @chicken_step.id).first.expected_qty == 2
  end

  test "generate_for aggregates the steps" do
    g = recipes(:green_onion)

    #green onion is now a subrecipe of chicken twice and sauce once
    StepInput.create!(inputable_id: g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: @sauce_step.id, quantity: 10, unit: "g")
    StepInput.create!(inputable_id: g.id, inputable_type: InputType::Recipe, 
      recipe_step_id: @chicken_step.id, quantity: 3, unit: "tbsp")

    count = DayPrep.count

    #7 total now
    new_pr = @purchased_recipe.dup
    new_pr.quantity = 3
    new_pr.save!

    DayPrep.generate_for(PurchasedRecipe.all, @today)

    assert DayPrep.count == count + 6
    #recipe serves 2, so we want 7/2 of it
    assert DayPrep.where(recipe_step_id: @chicken_step.id).first.expected_qty == 3.5

    green_onion_step = g.recipe_steps.first
    green_onion_prep = DayPrep.where(recipe_step_id: green_onion_step.id)
    assert green_onion_prep.count == 1
    #7/2 * ((0.5 * 10)/100 of recipe + (3 * 6)/100 of recipe + 80/100 of recipe)
    assert green_onion_prep.first.expected_qty == 3.605
  end
end
