class CreateRecipeSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_snapshots do |t|
      t.belongs_to :recipe, null: false
      t.string :unit
      t.float :output_qty, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_column :recipe_steps, :removed, :boolean, default: false, null: false
    remove_index :recipe_steps, :recipe_id
    add_index :recipe_steps, [:recipe_id, :removed]

    add_column :step_inputs, :removed, :boolean, default: false, null: false
    remove_index :step_inputs, :recipe_step_id
    add_index :step_inputs, [:recipe_step_id, :removed]

    create_join_table :recipe_snapshots, :recipe_steps do |t|
      t.index [:recipe_snapshot_id, :recipe_step_id], name: 'recipe_snapshot_step'
      t.index [:recipe_step_id, :recipe_snapshot_id], name: 'recipe_step_snapshot'
    end

    create_join_table :recipe_snapshots, :step_inputs do |t|
      t.index [:recipe_snapshot_id, :step_input_id], name: 'recipe_snapshot_input'
      t.index [:step_input_id, :recipe_snapshot_id], name: 'step_input_snapshot'
    end
  end
end
