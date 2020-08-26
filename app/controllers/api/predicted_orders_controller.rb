# typed: ignore
class Api::PredictedOrdersController < ApplicationController
  def index
    start_date = params[:start].to_date
    end_date = params[:end].to_date

    @predicted_orders = PredictedOrder
      .where(date: start_date..end_date)
      .where(kitchen_id: params[:kitchen_id])
      .includes(:recipe)
      .order(:date)

    render formats: :json
  end
end