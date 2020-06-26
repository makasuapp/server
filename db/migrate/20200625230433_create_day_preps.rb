class CreateDayPreps < ActiveRecord::Migration[5.2]
  def change
    create_table :day_preps do |t|
      t.belongs_to :op_day, null: false
      t.belongs_to :recipe_step, null: false
      t.float :expected_qty, null: false
      t.float :made_qty
      t.datetime :qty_updated_at

      t.timestamps
    end
  end
end
