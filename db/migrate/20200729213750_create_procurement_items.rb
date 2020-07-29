# typed: true
class CreateProcurementItems < ActiveRecord::Migration[5.2]
  def change
    create_table :procurement_items do |t|
      t.belongs_to :procurement_order, null: false
      t.belongs_to :ingredient, null: false
      t.float :quantity, null: false
      t.string :unit
      t.string :price_unit
      t.integer :price_cents
      t.float :got_qty
      t.string :got_unit
      t.timestamps
    end
  end
end
