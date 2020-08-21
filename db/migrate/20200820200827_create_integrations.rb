# typed: true
class CreateIntegrations < ActiveRecord::Migration[5.2]
  def change
    create_table :integrations do |t|
      t.belongs_to :kitchen, null: false
      t.string :integration_type, null: false
      t.string :wix_app_instance_id
      t.string :wix_restaurant_id

      t.timestamps
    end

    add_column :orders, :integration_id, :bigint
    add_column :orders, :integration_order_id, :string
  end
end
