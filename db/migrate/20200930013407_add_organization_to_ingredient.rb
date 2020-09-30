class AddOrganizationToIngredient < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :organization_id, :bigint
    add_index :ingredients, :organization_id
  end
end
