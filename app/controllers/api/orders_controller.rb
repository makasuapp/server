# typed: ignore
class Api::OrdersController < ApplicationController
  before_action :set_order, only: [:update_state]
  def index
    #hacky temp solution to have a dev environment
    if params[:env] == "dev"
      date = OpDay.first.date
    else
      #TODO(timezone)
      date = Time.now.in_time_zone("America/Toronto")
    end

    recipe_ids = PurchasedRecipe.where(date: date).map(&:recipe_id)
    @recipes = Recipe.all_in(recipe_ids)
    
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id))
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])
    
    #TODO(timezone)
    @orders = Order
      .on_date(date.to_date, "America/Toronto")
      .where.not(aasm_state: Order::STATE_DELIVERED)
      .includes([:order_items, :customer])

    #TODO: make this just the ingredients from the recipes
    @ingredients = Ingredient.all

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

  def update_items
    latest_updates = {}
    params[:updates].each do |x| 
      id = x[:id] 
      if latest_updates[id].nil? || x[:time_sec] > latest_updates[id][:time_sec]
        latest_updates[id] = x
      end
    end

    items = OrderItem.where(id: latest_updates.keys).map do |item|
      update = latest_updates[item.id]

      if update[:done_at].present?
        item.done_at = Time.at(update[:done_at])
      elsif update[:clear_done_at].present?
        item.done_at = nil
      end

      item
    end

    OrderItem.import items, on_duplicate_key_update: [:done_at]

    head :ok
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end