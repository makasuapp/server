# typed: true
class AddIndexToIntegration < ActiveRecord::Migration[5.2]
  def change
    add_index :integrations, [:integration_type, :wix_restaurant_id]
    add_index :orders, [:integration_id, :integration_order_id]
    remove_index :recipes, :kitchen_id
    add_index :recipes, [:kitchen_id, :name]
  end
end
