# typed: true
class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false

      t.timestamps
    end

    remove_column :users, :role, :integer
    add_column :recipes, :organization_id, :bigint
    remove_column :recipes, :kitchen_id, :bigint
    add_column :kitchens, :organization_id, :bigint
    add_index :recipes, [:organization_id, :name]
  end
end
