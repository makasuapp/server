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

  sig {params(purchased_recipes: PurchasedRecipe::ActiveRecord_Relation, op_day: OpDay).void} 
  def self.generate_for(purchased_recipes, op_day)
    day_preps = {}

    purchased_recipes.includes({recipe: {recipe_steps: :inputs}}).each do |pr|
      #create day prep for prep steps of the recipe
      prep_steps = pr.recipe.recipe_steps.select { |step| step.step_type == StepType::Prep }

      #create day prep for all steps of subrecipes
      subrecipes = pr.recipe.recipe_steps.map { |step| 
        step.inputs.select { |input| 
          input.inputable_type == InputType::Recipe
        }.map(&:inputable)
      }.flatten
      subrecipe_steps = subrecipes.map(&:all_steps).flatten

      #aggregates usages of the same step
      (prep_steps + subrecipe_steps).each do |step|
        existing_prep = day_preps[step.id]
        if existing_prep.nil?
          day_preps[step.id] = DayPrep.new(
            expected_qty: pr.quantity,
            op_day_id: op_day.id,
            recipe_step_id: step.id
          )
        else
          existing_prep.expected_qty = existing_prep.expected_qty + pr.quantity
          day_preps[step.id] = existing_prep
        end
      end
    end

    DayPrep.import! day_preps.values
  end
end
