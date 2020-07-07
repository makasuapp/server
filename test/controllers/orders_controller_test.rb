# typed: false
require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "" do
    c = customers(:one)
    @o = Order.create!(aasm_state: "new", order_type: "delivery", customer_id: c.id)
    assert @o.new?

    post "/api/orders/#{@o.id}/update_state", params: { 
      state_action: "start"
    }, as: :json

    assert_response 200
    assert !@o.reload.new?
    assert @o.started?
  end
end