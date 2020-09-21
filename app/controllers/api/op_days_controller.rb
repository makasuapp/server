# typed: false
class Api::OpDaysController < ApplicationController
  def index
    #TODO(timezone)
    date = DateTime.now.in_time_zone("America/Toronto")
    start_date = date.beginning_of_day
    end_date = date.end_of_day

    @inputs = DayInput
      .where(kitchen_id: params[:kitchen_id])
      .where(min_needed_at: start_date..end_date)
    @preps = DayPrep
      .where(kitchen_id: params[:kitchen_id])
      .where(min_needed_at: start_date..end_date)

    render formats: :json
  end

  #TODO(day_recipe): test
  def add_inputs
    #TODO(timezone)
    date = DateTime.now.in_time_zone("America/Toronto")
    kitchen = Kitchen.find(params[:kitchen_id])
    op_day = OpDay.find_by(date: date, kitchen_id: kitchen.id)

    inputs = []

    params[:inputs].each do |input|
      inputs << DayInput.new(
        expected_qty: input[:qty],
        had_qty: input[:qty],
        inputable_type: input[:inputable_type],
        inputable_id: input[:inputable_id],
        unit: input[:unit],
        #TODO: this time is a bit arbitrary and is set here + in op_day_manager
        min_needed_at: date.beginning_of_day,
        qty_updated_at: date,
        kitchen_id: kitchen.id,
        op_day_id: op_day.id
      )
    end

    DayInput.import inputs

    #TODO(day_recipe): based on new day input, modify ingredients/prep
    # OpDayManager.update_day_for(date, kitchen)

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