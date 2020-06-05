# typed: ignore
class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.decimal :output_quantity, precision: 6, scale: 2, null: false, default: 1

      t.string :unit

      t.timestamps
    end
  end
end
