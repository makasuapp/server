# typed: ignore
class Api::InventoryController < ApplicationController
  def index
    # date = Time.now.in_time_zone("America/Toronto").to_date
    # op_day = OpDay.find_or_create_by!(date: date)
    op_day = OpDay.first

    @ingredients = DayIngredient.where(op_day_id: op_day.id)
    render formats: :json
  end

  def save_qty
    ids = params[:updates].map { |x| x[:id] }.flatten
    ingredients_map = {}
    DayIngredient.where(id: ids).each do |i|
      ingredients_map[i.id.to_s] = i
    end

    params[:updates].each do |update|
      update_time = update.try(:[], "time_sec")
      ingredient = ingredients_map[update.try(:[], "id").to_s]

      if update_time.present? && ingredient.present? && 
        (ingredient.qty_updated_at.nil? || update_time > ingredient.qty_updated_at.to_i)

        ingredient.had_qty = update[:had_qty]
        ingredient.qty_updated_at = Time.at(update_time)

        ingredients_map[ingredient.id.to_s] = ingredient
      end
    end

    DayIngredient.import ingredients_map.values, on_duplicate_key_update: [:had_qty, :qty_updated_at]

    head :ok
  end
end