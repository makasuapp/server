class AddIndicesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_index :orders, [:for_time, :created_at, :aasm_state]
  end
end
