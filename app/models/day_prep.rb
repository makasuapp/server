# typed: strict
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
class DayPrep < ApplicationRecord
  extend T::Sig

  belongs_to :recipe_step
  belongs_to :op_day

  sig {params(predicted_orders: PredictedOrder::ActiveRecord_Relation, op_day: OpDay).void} 
  def self.generate_for(predicted_orders, op_day)
    day_preps = {}

    predicted_orders.includes({recipe: {recipe_steps: :inputs}}).each do |pr|
      recipe = pr.recipe
      recipe_servings = recipe.servings_produced(pr.quantity)

      #create day prep for prep steps of the recipe
      prep_step_amounts = recipe.recipe_steps
        .select { |step| step.step_type == StepType::Prep }
        .map { |step| StepAmount.mk(step.id, 1) }
      
      #create day prep for all steps of subrecipes
      subrecipe_step_amounts = recipe.recipe_steps.map { |step| 
        step.inputs.select { |input| 
          input.inputable_type == InputType::Recipe
        }.map { |recipe_input|
          child_recipe = recipe_input.inputable
          child_steps = child_recipe.step_amounts

          num_servings = child_recipe.servings_produced(recipe_input.quantity, recipe_input.unit)
          child_step_amounts = child_steps.map { |x| x * num_servings }
        }
      }.flatten

      (prep_step_amounts + subrecipe_step_amounts).each do |step_amount|
        existing_prep = day_preps[step_amount.recipe_step_id]
        additional_qty = step_amount.quantity * recipe_servings

        if existing_prep.nil?
          day_preps[step_amount.recipe_step_id] = DayPrep.new(
            expected_qty: additional_qty,
            op_day_id: op_day.id,
            recipe_step_id: step_amount.recipe_step_id
          )
        else
          existing_prep.expected_qty = existing_prep.expected_qty + additional_qty
          day_preps[step_amount.recipe_step_id] = existing_prep
        end
      end
    end

    DayPrep.import! day_preps.values
  end
end
