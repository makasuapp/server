# typed: ignore
class Api::OrdersController < ApplicationController
  before_action :set_order, only: [:update_state]
  def index
    # date = Time.now.in_time_zone("America/Toronto")
    date = OpDay.first.date

    recipe_ids = PurchasedRecipe.where(date: date).map(&:recipe_id)
    @recipes = Recipe.all_in(recipe_ids)
    
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id))
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])
    
    @orders = Order
      .on_date(date)
      .where.not(aasm_state: Order::STATE_DELIVERED)
      .includes([:order_items, :customer])

    render formats: :json
  end

  def update_state
    begin
      @order.aasm.fire!(params[:state_action])
      head :ok
    rescue => e
      render json: e, status: :unprocessable_entity and return
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end