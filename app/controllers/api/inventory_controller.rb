# typed: ignore
class Api::InventoryController < ApplicationController
  def index
    date = Date.today
    op_day = OpDay.find_or_create_by!(date: date)

    @ingredients = DayIngredient.where(op_day_id: op_day.id)
    render formats: :json
  end
end