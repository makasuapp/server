# typed: true
class CreatePurchasedRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :purchased_recipes do |t|
      t.date :date, null: false, index: true
      t.integer :quantity
      t.belongs_to :recipe

      t.timestamps
    end
  end
end
