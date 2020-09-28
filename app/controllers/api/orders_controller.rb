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
    @order.for_time = Time.at(base_order_params[:for_time].to_i / 1000)
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

      response = Firebase.new.send_notification_with_data(@order.topic_name, 
        "New Order", "new_order", order_json)
    rescue => e
      Raven.capture_exception(e)
    end

    render :show, status: :created
  end

  def index
    if params[:date].present?
      date = Time.at(params[:date])
    else
      #TODO(timezone)
      date = Time.now.in_time_zone("America/Toronto")
    end

    kitchen = Kitchen.find_by(id: params[:kitchen_id])
    @recipes = Recipe.where(organization_id: kitchen.organization_id)
    
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id))
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])
    
    @orders = Order
      .where(kitchen_id: kitchen.id)
      .includes([:order_items, :customer, :integration])

    #TODO(timezone)
    if params[:all]
      @orders = @orders
        .on_date(date.to_date, "America/Toronto")
    else
      @orders = @orders
        .before_date(date.to_date, "America/Toronto")
        .where.not(aasm_state: Order::STATE_DELIVERED)
    end

    #TODO: make this just the ingredients from the recipes
    @ingredients = Ingredient.all

    render formats: :json
  end

  def update_state
    begin
      @order.aasm.fire!(params[:state_action])
    rescue => e
      Raven.capture_exception(e)
    end

    render :show
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