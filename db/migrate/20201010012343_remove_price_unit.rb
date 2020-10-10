class RemovePriceUnit < ActiveRecord::Migration[5.2]
  def change
    remove_column :procurement_items, :price_unit
    remove_column :recipe_steps, :output_name
  end
end
