class AddTokenToUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :email, :string, null: true
    change_column_default :users, :email, nil
    add_column :users, :role, :string

    add_column :users, :kitchen_token, :string
    add_index :users, :kitchen_token, unique: true
  end
end
