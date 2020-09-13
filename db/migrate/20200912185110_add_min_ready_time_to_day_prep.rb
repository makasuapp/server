class AddMinReadyTimeToDayPrep < ActiveRecord::Migration[5.2]
  def change
    add_column :day_preps, :min_needed_at, :datetime
    add_column :day_ingredients, :min_needed_at, :datetime

    add_column :day_preps, :kitchen_id, :bigint
    add_column :day_ingredients, :kitchen_id, :bigint

    add_index :day_preps, [:kitchen_id, :min_needed_at]
    add_index :day_ingredients, [:kitchen_id, :min_needed_at]
  end
end
