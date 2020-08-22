# typed: false
class WixController < ApplicationController
  def orders_webhook
    wix_restaurant_id = params[:restaurant][:id]
    menu_json = params[:menu].to_json
    wix_menu = Wix::MenuRepresenter.new(Wix::Menu.new).from_json(menu_json)
    order_json = params[:order].to_json
    wix_order = Wix::OrderRepresenter.new(Wix::Order.new).from_json(order_json)

    integration = Integration.find_by(integration_type: IntegrationType::Wix, wix_restaurant_id: wix_restaurant_id)
    if integration.nil?
      Raven.capture_exception("no integration found for restaurant id #{wix_restaurant_id}")
      head :not_found
      return
    else
      existing_order = Order.find_by(integration_id: integration.id, integration_order_id: wix_order.id)

      if existing_order.present?
        Raven.capture_exception("existing wix order found. what was webhook triggering? #{wix_order.to_json}")
        head :ok
        return
      end

      wix_contact = wix_order.contact
      customer = Customer.assign_or_init_by_contact(wix_contact.phone, wix_contact.email, wix_contact.to_params)
      if !customer.save
        Raven.capture_exception(customer.errors)
        render json: customer.errors, status: :unprocessable_entity
        return
      end

      #TODO(wix): how get order type?
      order = Order.new(order_type: "pickup", customer_id: customer.id, kitchen_id: integration.kitchen_id,
        for_time: wix_order.for_time)
      
      if !order.save
        Raven.capture_exception(order.errors)
        render json: order.errors, status: :unprocessable_entity
        return
      end

      wix_items = wix_menu.items

      recipe_map = {}
      wix_items.each do |wix_item|
        #TODO(wix): is going by title the best idea?
        recipe = Recipe.find_by(kitchen_id: integration.kitchen_id, name: wix_item.name)
        recipe_map[wix_item.id] = recipe
      end

      wix_order.order_items.each do |item|
        oi = OrderItem.new
        oi.order_id = order.id
        oi.quantity = item.count
        oi.price_cents = item.price

        recipe = recipe_map[item.item_id]
        if recipe.nil?
          Raven.capture_exception("no recipe found for item id #{item.item_id}")
          head :unprocessable_entity
          return
        end

        oi.recipe_id = recipe.id

        if !oi.save
          Raven.capture_exception(oi.errors)
          render json: oi.errors, status: :unprocessable_entity
          return
        end
      end

      begin
        order_json = ActionController::Base.new.view_context.render(
          partial: "api/orders/order", locals: {order: order})

        response = Firebase.new.send_data(order.topic_name, "new_order", order_json)
      rescue => e
        Raven.capture_exception(e)
      end

      head :ok
    end
  end
end