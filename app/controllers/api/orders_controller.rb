# typed: ignore
class Api::OrdersController < ApplicationController
  before_action :set_order, only: [:update_state]

  def create
    @customer = Customer.assign_or_init_by_contact(customer_params[:phone_number], 
      customer_params[:email], customer_params)

    if !@customer.save
      Raven.capture_exception(@customer.errors)
      render json: @customer.errors, status: :unprocessable_entity
      return
    end

    @order = Order.new(base_order_params)
    @order.customer_id = @customer.id

    if !@order.save
      Raven.capture_exception(@order.errors)
      render json: @order.errors, status: :unprocessable_entity
      return
    end

    if order_params[:order_items].present?
      #might have to change this when we change it to an internet form
      order_params[:order_items].each do |idx, item_params|
        @item = OrderItem.new
        @item.assign_attributes(item_params)
        @item.order_id = @order.id

        if !@item.save
          Raven.capture_exception(@item.errors)
          render json: @item.errors, status: :unprocessable_entity
          return
        end
      end
    end

    begin
      order_json = ActionController::Base.new.view_context.render(
        partial: "api/orders/order", locals: {order: @order})

      response = Firebase.new.send_data(@order.topic_name, "new_order", order_json)
    rescue => e
      Raven.capture_exception(e)
    end

    render :show, status: :created
  end

  def index
    #hacky temp solution to have a dev environment
    if params[:env] == "dev"
      date = OpDay.first.date
    else
      #TODO(timezone)
      date = Time.now.in_time_zone("America/Toronto")
    end

    recipe_ids = PredictedOrder.where(date: date, kitchen_id: params[:kitchen_id]).map(&:recipe_id)
    @recipes = Recipe.all_in(recipe_ids)
    
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id))
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])
    
    #TODO(timezone)
    @orders = Order
      .where(kitchen_id: params[:kitchen_id])
      .on_date(date.to_date, "America/Toronto")
      .includes([:order_items, :customer, :integration])

    unless params[:all]
      @orders = @orders.where.not(aasm_state: Order::STATE_DELIVERED)
    end

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

  def base_order_params
    params.require(:order).permit(:order_type, :for_time, :kitchen_id)
  end

  def order_params
    params.require(:order).permit(:order_type, :for_time, :kitchen_id, order_items: [
      :price_cents, :quantity, :recipe_id
    ])
  end

  def customer_params
    params.require(:customer).permit(:email, :first_name, :last_name, :phone_number)
  end
end