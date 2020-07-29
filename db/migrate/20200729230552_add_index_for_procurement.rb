class AddIndexForProcurement < ActiveRecord::Migration[5.2]
  def change
    add_index :procurement_orders, :for_date
  end
end
