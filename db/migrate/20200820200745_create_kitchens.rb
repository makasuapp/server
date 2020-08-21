# typed: true
class CreateKitchens < ActiveRecord::Migration[5.2]
  def change
    create_table :kitchens do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_column :recipes, :kitchen_id, :bigint
    add_index :recipes, :kitchen_id

    add_column :purchased_recipes, :kitchen_id, :bigint
    add_index :purchased_recipes, [:date, :kitchen_id]

    add_column :op_days, :kitchen_id, :bigint
    add_index :op_days, [:date, :kitchen_id]

    add_column :orders, :kitchen_id, :bigint
    remove_index :orders, [:for_time, :created_at, :aasm_state]
    add_index :orders, [:kitchen_id, :for_time, :created_at, :aasm_state], name: "idx_kitchen_time"

    add_column :procurement_orders, :kitchen_id, :bigint
    remove_index :procurement_orders, :for_date
    add_index :procurement_orders, [:kitchen_id, :for_date]
  end
end
