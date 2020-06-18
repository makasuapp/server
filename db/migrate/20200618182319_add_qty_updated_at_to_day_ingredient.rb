class AddQtyUpdatedAtToDayIngredient < ActiveRecord::Migration[5.2]
  def change
    add_column :day_ingredients, :qty_updated_at, :datetime
  end
end
