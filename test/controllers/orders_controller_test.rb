# typed: false
require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @c = customers(:one)
    @o = orders(:delivery)
  end

  test "update_state" do
    assert @o.new?

    post "/api/orders/#{@o.id}/update_state", params: { 
      state_action: "start"
    }, as: :json

    assert_response 200
    assert !@o.reload.new?
    assert @o.started?
  end

  test "update_items updates done_at to latest version" do
    o2 = orders(:pickup)
    item1 = order_items(:delivery_item)
    item2 = order_items(:pickup_item)

    now = DateTime.now
    item2.update_attributes!(done_at: now)

    updates = []
    updates << {id: item1.id, done_at: (now - 1.hour).to_i, clear_done_at: nil, time_sec: (now - 2.days).to_i}
    updates << {id: item2.id, clear_done_at: true, done_at: nil, time_sec: (now - 2.hours).to_i}
    updates << {id: item1.id, done_at: now.to_i, clear_done_at: nil, time_sec: now.to_i}
    updates << {id: item1.id, done_at: (now - 2.hour).to_i, clear_done_at: nil, time_sec: (now - 1.hour).to_i}

    post "/api/orders/update_items", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert item1.reload.done_at.to_i == now.to_i
    assert item2.reload.done_at.nil?
  end

  test "create order for existing customer updates info" do
    orders_count = Order.count

    c = customers(:one)
    assert c.phone_number.nil?
    phone_number = "1234567890"

    r1 = recipes(:chicken)
    r2 = recipes(:green_onion)
    for_time = DateTime.now + 2.hours

    Firebase.any_instance.expects(:send_data).once
    post "/api/orders", params: { 
      customer: {
        email: c.email,
        phone_number: phone_number,
        first_name: "Test Tester"
      },
      order: {
        order_type: "delivery",
        for_time: for_time,
        order_items: [
          {
            price_cents: 2000,
            quantity: 2,
            recipe_id: r1.id
          },
          {
            price_cents: 100,
            quantity: 1,
            recipe_id: r2.id
          }
        ]
      }
    }, as: :json

    assert Order.count == orders_count + 1
    order = Order.last
    assert order.customer_id == c.id
    assert c.reload.phone_number == phone_number
    assert order.order_items.length == 2
    assert order.for_time.to_i == for_time.to_i
  end
end