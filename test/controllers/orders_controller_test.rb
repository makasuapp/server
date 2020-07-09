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
    updates << {id: item1.id, done_at: now - 1.hour, time_sec: (now - 2.days).to_i}
    updates << {id: item2.id, clear_done_at: true, time_sec: (now - 2.hours).to_i}
    updates << {id: item1.id, done_at: now, time_sec: now.to_i}
    updates << {id: item1.id, done_at: now - 2.hour, time_sec: (now - 1.hour).to_i}

    post "/api/orders/update_items", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert item1.reload.done_at.to_i == now.to_i
    assert item2.reload.done_at.nil?
  end
end