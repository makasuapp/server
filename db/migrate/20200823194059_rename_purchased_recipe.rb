class RenamePurchasedRecipe < ActiveRecord::Migration[5.2]
  def change
    rename_table :purchased_recipes, :predicted_orders
  end
end
