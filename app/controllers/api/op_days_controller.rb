# typed: false
class Api::OpDaysController < ApplicationController
  def set_variables
    start_date = @date.beginning_of_day
    end_date = @date.end_of_day

    kitchen = Kitchen.find(params[:kitchen_id])

    @inputs = DayInput
      .where(kitchen_id: kitchen.id)
      .where(min_needed_at: start_date..end_date)
    @preps = DayPrep
      .where(kitchen_id: kitchen.id)
      .where(min_needed_at: start_date..end_date)
    @predicted_orders = PredictedOrder
      .where(date: start_date..end_date)
      .where(kitchen_id: kitchen.id)

    @recipes = Recipe.where(organization_id: kitchen.organization_id)
    
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id), removed: false)
      .or(RecipeStep.where(id: @preps.map(&:recipe_step_id)))
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])
      .distinct

    @ingredients = Ingredient.where(organization_id: kitchen.organization_id)
  end

  def index
    #TODO(timezone)
    if params[:date].present?
      @date = Time.at(params[:date].to_i).in_time_zone("America/Toronto")
    else
      @date = DateTime.now.in_time_zone("America/Toronto")
    end

    set_variables
    render formats: :json
  end

  def add_inputs
    #TODO(timezone)
    if params[:date].present?
      @date = Time.at(params[:date].to_i).in_time_zone("America/Toronto")
    else
      @date = DateTime.now.in_time_zone("America/Toronto")
    end

    kitchen = Kitchen.find(params[:kitchen_id])
    op_day = OpDay.find_or_create_by!(date: @date, kitchen_id: kitchen.id)

    inputs = []

    params[:inputs].each do |input|
      inputs << DayInput.new(
        expected_qty: input[:qty],
        had_qty: input[:qty],
        inputable_type: input[:inputable_type],
        inputable_id: input[:inputable_id],
        unit: input[:unit],
        min_needed_at: DayInput.day_needed_at(@date),
        qty_updated_at: @date,
        kitchen_id: kitchen.id,
        op_day_id: op_day.id
      )
    end

    DayInput.import inputs

    OpDayManager.update_day_for(op_day)

    set_variables
    render :index, status: :created
  end

  def save_inputs_qty
    ids = params[:updates].map { |x| x[:id] }.flatten
    inputs_map = {}
    DayInput.where(id: ids).each do |i|
      inputs_map[i.id.to_s] = i
    end

    params[:updates].each do |update|
      update_time = update.try(:[], "time_sec")
      input = inputs_map[update.try(:[], "id").to_s]

      if update_time.present? && input.present? && 
        (input.qty_updated_at.nil? || update_time > input.qty_updated_at.to_i)

        input.had_qty = update[:had_qty]
        input.qty_updated_at = Time.at(update_time)

        inputs_map[input.id.to_s] = input
      end
    end

    DayInput.import inputs_map.values, on_duplicate_key_update: [:had_qty, :qty_updated_at]

    #if a recipe input changes, we need to update the day's inputs/preps
    recipe_updates = DayInput.where(id: ids, inputable_type: DayInputType::Recipe)
    if recipe_updates.size > 0
      #assume updates are all from same day
      op_day = recipe_updates.first.op_day
      OpDayManager.update_day_for(op_day)
    end

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