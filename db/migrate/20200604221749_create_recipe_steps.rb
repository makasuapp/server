# typed: ignore
class CreateRecipeSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_steps do |t|
      t.belongs_to :recipe, null: false
      t.string :step_type, null: false
      t.integer :number, null: false
      t.text :instruction, null: false

      t.integer :duration_sec
      t.integer :max_before_sec
      t.integer :min_before_sec

      t.timestamps
    end

    add_index :recipe_steps, :step_type
  end
end
