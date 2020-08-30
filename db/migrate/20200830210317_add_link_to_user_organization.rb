class AddLinkToUserOrganization < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :kitchen_token
    add_column :user_organizations, :auth_token, :string
    add_column :user_organizations, :access_link, :string
    add_index :user_organizations, :auth_token, unique: true
  end
end
