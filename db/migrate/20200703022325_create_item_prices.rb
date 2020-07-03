# typed: true
class CreateItemPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :item_prices do |t|
      t.belongs_to :recipe
      t.integer :price_cents, null: false
      t.timestamps
    end

    add_column :recipes, :current_price_cents, :integer
  end
end
