# typed: true
class CreateUserOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_organizations do |t|
      t.bigint :user_id, null: false
      t.bigint :organization_id, null: false
      t.string :role, null: false
      t.bigint :kitchen_id

      t.timestamps
    end

    add_index :user_organizations, [:organization_id, :user_id], name: 'organizations_users_idx'
    add_index :user_organizations, [:user_id, :organization_id], name: 'users_organizations_idx'
  end
end
