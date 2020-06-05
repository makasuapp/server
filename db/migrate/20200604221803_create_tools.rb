# typed: ignore
class CreateTools < ActiveRecord::Migration[5.2]
  def change
    create_table :tools do |t|
      t.string :name, null: false, unique: true
      t.timestamps
    end

    create_join_table :tools, :recipe_steps do |t|
      t.index [:tool_id, :recipe_step_id], name: 'tool_recipe_step'
      t.index [:recipe_step_id, :tool_id], name: 'recipe_step_tool'
    end
  end
end
