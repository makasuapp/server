# typed: true
class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, null: false
      t.belongs_to :recipe, null: false
      t.integer :quantity, null: false
      t.datetime :started_at
      t.datetime :done_at
      t.integer :price_cents, null: false
      t.timestamps
    end
  end
end
