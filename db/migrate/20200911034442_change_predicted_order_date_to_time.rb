class ChangePredictedOrderDateToTime < ActiveRecord::Migration[5.2]
  def change
    change_column :predicted_orders, :date, :datetime, null: false
  end
end
