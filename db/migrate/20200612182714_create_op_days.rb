# typed: true
class CreateOpDays < ActiveRecord::Migration[5.2]
  def change
    create_table :op_days do |t|
      t.date :date, null: false, index: true
      
      t.timestamps
    end
  end
end
