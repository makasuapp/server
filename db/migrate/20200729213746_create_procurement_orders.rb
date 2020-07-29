# typed: true
class CreateProcurementOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :procurement_orders do |t|
      t.belongs_to :vendor, null: false
      t.datetime :for_date, null: false
      t.string :order_type, null: false
      t.timestamps
    end
  end
end
