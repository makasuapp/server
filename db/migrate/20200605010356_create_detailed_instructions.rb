# typed: ignore
class CreateDetailedInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :detailed_instructions do |t|
      t.text :instruction, null: false

      t.timestamps
    end

    create_join_table :detailed_instructions, :recipe_steps do |t|
      t.index [:detailed_instruction_id, :recipe_step_id], name: 'detailed_instruction_recipe_step'
      t.index [:recipe_step_id, :detailed_instruction_id], name: 'recipe_step_detailed_instruction'
    end
  end
end
