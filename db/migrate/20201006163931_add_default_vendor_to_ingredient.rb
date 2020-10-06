class AddDefaultVendorToIngredient < ActiveRecord::Migration[5.2]
  def change
    add_column :vendors, :organization_id, :bigint
    add_index :vendors, :organization_id
    add_column :ingredients, :default_vendor_id, :bigint
  end
end
