# typed: true
class AddNameToRecipeStep < ActiveRecord::Migration[5.2]
  def change
    add_column :recipe_steps, :output_name, :string
  end
end
