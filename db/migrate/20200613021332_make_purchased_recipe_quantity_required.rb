# typed: true
class MakePurchasedRecipeQuantityRequired < ActiveRecord::Migration[5.2]
  def change
    change_column :purchased_recipes, :quantity, :integer, null: false
    change_column :purchased_recipes, :recipe_id, :bigint, null: false
    change_column :day_ingredients, :expected_qty, :decimal, precision: 6, scale: 2, null: false
    change_column :day_ingredients, :had_qty, :decimal, precision: 6, scale: 2
    change_column :day_ingredients, :ingredient_id, :bigint, null: false
    change_column :day_ingredients, :op_day_id, :bigint, null: false
  end
end
