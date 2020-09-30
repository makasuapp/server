class MakeIngredientOrgNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column :ingredients, :organization_id, :bigint, null: false
  end
end
