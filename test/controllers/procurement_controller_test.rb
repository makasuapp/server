# typed: false
require 'test_helper'

class ProcurementControllerTest < ActionDispatch::IntegrationTest
  setup do
    @salt = procurement_items(:salt)
    @chicken = procurement_items(:chicken)
    @salt.update_attributes!(got_qty: 1, got_unit: "g", price_cents: 1000)
  end

  test "update_items updates qty and price" do
    assert @salt.got_qty == 1

    updates = []
    updates << {id: @salt.id}
    updates << {id: @chicken.id, got_qty: 2.5, price_cents: 2000}
    updates << {id: @chicken.id, got_qty: 3.5, price_cents: 2500}

    post "/api/procurement/update_items", params: { 
      updates: updates
    }, as: :json

    assert_response 200
    assert @salt.reload.got_qty.nil?
    assert @salt.got_unit.nil?
    assert @salt.price_cents.nil?

    assert @chicken.reload.got_qty == 3.5
    assert @chicken.got_unit.nil?
    assert @chicken.price_cents == 2500
  end
end