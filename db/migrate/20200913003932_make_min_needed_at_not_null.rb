class MakeMinNeededAtNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column :day_preps, :min_needed_at, :datetime, null: false
    change_column :day_preps, :kitchen_id, :bigint, null: false
    change_column :day_ingredients, :min_needed_at, :datetime, null: false
    change_column :day_ingredients, :kitchen_id, :bigint, null: false
  end
end
