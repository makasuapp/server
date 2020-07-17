# typed: ignore
class Api::OpDaysController < ApplicationController
  def index
    #hacky temp solution to have a dev environment
    if params[:env] == "dev"
      op_day = OpDay.first
    else
      date = Time.now.in_time_zone("America/Toronto").to_date
      op_day = OpDay.find_or_create_by!(date: date)
    end

    @ingredients = DayIngredient.where(op_day_id: op_day.id).includes(:ingredient)
    @preps = DayPrep.where(op_day_id: op_day.id)

    #TODO(day_prep): also pull all DayIngredient/DayPrep where date is > today and joined on RecipeStep, date + min seconds < end of today 
    #TODO(day_prep): optional = DayIngredient/DayPrep where date is tomorrow 

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