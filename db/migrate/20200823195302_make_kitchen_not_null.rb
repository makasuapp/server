class MakeKitchenNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column :recipes, :kitchen_id, :bigint, null: false
    change_column :predicted_orders, :kitchen_id, :bigint, null: false
    change_column :op_days, :kitchen_id, :bigint, null: false
    change_column :orders, :kitchen_id, :bigint, null: false
    change_column :procurement_orders, :kitchen_id, :bigint, null: false
  end
end
