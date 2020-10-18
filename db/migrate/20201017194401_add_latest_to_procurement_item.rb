class AddLatestToProcurementItem < ActiveRecord::Migration[5.2]
  def up
    add_column :procurement_items, :latest_price, :boolean, null: false, default: true
    remove_index :procurement_items, :ingredient_id
    add_index :procurement_items, [:ingredient_id, :latest_price, :price_cents], name: "procurement_items_latest_idx"
    change_column :procurement_items, :procurement_order_id, :bigint, null: true
  end

  def down
    remove_column :procurement_items, :latest_price
    add_index :procurement_items, :ingredient_id
    change_column :procurement_items, :procurement_order_id, :bigint, null: false
  end
end
