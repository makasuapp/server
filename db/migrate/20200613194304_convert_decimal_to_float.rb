class ConvertDecimalToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :day_ingredients, :expected_qty, :float, null: false
    change_column :day_ingredients, :had_qty, :float
    change_column :recipes, :output_quantity, :float, null: false, default: 1
    rename_column :recipes, :output_quantity, :output_qty
    change_column :step_inputs, :quantity, :float, null: false, default: 1
  end
end
