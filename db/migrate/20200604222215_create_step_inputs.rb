# typed: ignore
class CreateStepInputs < ActiveRecord::Migration[5.2]
  def change
    create_table :step_inputs do |t|
      t.belongs_to :recipe_step, null: false
      t.bigint :inputable_id, null: false
      t.string :inputable_type, null: false
      t.decimal :quantity, precision: 6, scale: 2, null: false, default: 1

      t.string :unit

      t.timestamps
    end

    add_index :step_inputs, [:inputable_type, :inputable_id]
  end
end
