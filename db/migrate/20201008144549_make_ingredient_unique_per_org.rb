class MakeIngredientUniquePerOrg < ActiveRecord::Migration[5.2]
  def change
    add_index :ingredients, [:organization_id, :name], unique: true
    change_column :vendors, :organization_id, :bigint, null: false
    change_column :ingredients, :default_vendor_id, :bigint, null: false
  end
end
