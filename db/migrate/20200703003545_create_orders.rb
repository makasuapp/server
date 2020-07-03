# typed: true
class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :aasm_state, null: false
      t.string :order_type, null: false
      t.datetime :for_time
      t.belongs_to :customer, null: false
      t.timestamps
    end
  end
end
