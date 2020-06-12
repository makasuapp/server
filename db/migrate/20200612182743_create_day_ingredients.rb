# typed: true
class CreateDayIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :day_ingredients do |t|
      t.belongs_to :op_day
      t.belongs_to :ingredient
      t.integer :had_qty
      t.integer :expected_qty
      t.string :unit

      t.timestamps
    end
  end
end
