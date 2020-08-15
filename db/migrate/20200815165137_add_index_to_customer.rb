class AddIndexToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_index :customers, :phone_number
    add_index :customers, :email
  end
end
