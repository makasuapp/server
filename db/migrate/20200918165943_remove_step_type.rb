class RemoveStepType < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipe_steps, :step_type
    add_index :recipes, [:organization_id, :publish]
  end
end
