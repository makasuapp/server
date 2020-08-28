class MakeOrganizationNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column :recipes, :organization_id, :bigint, null: false
    change_column :kitchens, :organization_id, :bigint, null: false
  end
end
