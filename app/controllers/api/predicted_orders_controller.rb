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

  def create
    date = Time.at(params[:date_ms].to_i / 1000)
    @predicted_orders = []

    if params[:predicted_orders].present?
      #might have to change this when we change it to an internet form
      params[:predicted_orders].each do |idx, order_params|
        order = PredictedOrder.new
        order.quantity = order_params[:quantity]
        order.recipe_id = order_params[:recipe_id]
        order.kitchen_id = params[:kitchen_id]
        order.date = date

        if order.save
          @predicted_orders << order
        else
          Raven.capture_exception(order.errors)
          render json: order.errors, status: :unprocessable_entity
          return
        end
      end
    end

    render :index, status: :created
  end

  def update_for_date
    date = Time.at(params[:date_ms].to_i / 1000)
    @predicted_orders = []

    #might not be the best way to update
    PredictedOrder.where(date: date).delete_all

    if params[:predicted_orders].present?
      #might have to change this when we change it to an internet form
      params[:predicted_orders].each do |idx, order_params|
        order = PredictedOrder.new
        order.quantity = order_params[:quantity]
        order.recipe_id = order_params[:recipe_id]
        order.kitchen_id = params[:kitchen_id]
        order.date = date

        if order.save
          @predicted_orders << order
        else
          Raven.capture_exception(order.errors)
          render json: order.errors, status: :unprocessable_entity
          return
        end
      end
    end

    render :index, status: :created
  end
end