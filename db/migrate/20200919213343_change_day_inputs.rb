class ChangeDayInputs < ActiveRecord::Migration[5.2]
  def change
    rename_table :day_ingredients, :day_inputs
    remove_index :day_inputs, :ingredient_id
    rename_column :day_inputs, :ingredient_id, :inputable_id
    add_column :day_inputs, :inputable_type, :string, null: false, default: "Ingredient"
    add_index :day_inputs, [:inputable_type, :inputable_id]
  end
end
