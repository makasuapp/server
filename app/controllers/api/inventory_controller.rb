# typed: ignore
class Api::InventoryController < ApplicationController
  before_action :set_day_ingredient, only: [:save_qty]

  def index
    date = Date.today
    op_day = OpDay.find_or_create_by!(date: date)

    @ingredients = DayIngredient.where(op_day_id: op_day.id)
    render formats: :json
  end

  def save_qty
    @day_ingredient.update_attributes!(had_qty: day_ingredient_params[:had_qty])

    head :ok
  end

  private
  def set_day_ingredient
    @day_ingredient = DayIngredient.find(params[:id])
  end

  def day_ingredient_params
    params.require(:day_ingredient).permit(:had_qty)
  end
end