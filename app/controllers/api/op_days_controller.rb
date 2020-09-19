# typed: false
class Api::OpDaysController < ApplicationController
  def index
    #TODO(timezone)
    date = DateTime.now.in_time_zone("America/Toronto")
    start_date = date.beginning_of_day
    end_date = date.end_of_day

    @ingredients = DayIngredient
      .where(kitchen_id: params[:kitchen_id])
      .where(min_needed_at: start_date..end_date)
    .includes(:ingredient)
    @preps = DayPrep
      .where(kitchen_id: params[:kitchen_id])
      .where(min_needed_at: start_date..end_date)

    render formats: :json
  end

  def save_ingredients_qty
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

  def save_prep_qty
    ids = params[:updates].map { |x| x[:id] }.flatten
    prep_map = {}
    DayPrep.where(id: ids).each do |i|
      prep_map[i.id.to_s] = i
    end

    params[:updates].each do |update|
      update_time = update.try(:[], "time_sec")
      prep = prep_map[update.try(:[], "id").to_s]

      if update_time.present? && prep.present? && 
        (prep.qty_updated_at.nil? || update_time > prep.qty_updated_at.to_i)

        prep.made_qty = update[:made_qty]
        prep.qty_updated_at = Time.at(update_time)

        prep_map[prep.id.to_s] = prep
      end
    end

    DayPrep.import prep_map.values, on_duplicate_key_update: [:made_qty, :qty_updated_at]

    head :ok
  end
end