# typed: strict
# == Schema Information
#
# Table name: day_ingredients
#
#  id            :bigint           not null, primary key
#  expected_qty  :float            not null
#  had_qty       :float
#  unit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :bigint           not null
#  op_day_id     :bigint           not null
#
# Indexes
#
#  index_day_ingredients_on_ingredient_id  (ingredient_id)
#  index_day_ingredients_on_op_day_id      (op_day_id)
#
class DayIngredient < ApplicationRecord
  extend T::Sig

  belongs_to :ingredient
  belongs_to :op_day

  sig {params(purchased_recipes: PurchasedRecipe::ActiveRecord_Relation, op_day: OpDay).void} 
  def self.generate_for(purchased_recipes, op_day)
    ingredient_amounts = purchased_recipes.map(&:ingredient_amounts).flatten
    aggregated_amounts = IngredientAmount.sum_by_id(ingredient_amounts)

    day_ingredients = aggregated_amounts.map do |a|
      DayIngredient.new(
        ingredient_id: a.ingredient_id,
        expected_qty: a.quantity,
        unit: a.unit,
        op_day_id: op_day.id
      )
    end
    DayIngredient.import! day_ingredients
  end
end
