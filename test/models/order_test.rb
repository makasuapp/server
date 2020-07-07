# typed: strict
# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  aasm_state  :string           not null
#  for_time    :datetime
#  order_type  :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_orders_on_customer_id                             (customer_id)
#  index_orders_on_for_time_and_created_at_and_aasm_state  (for_time,created_at,aasm_state)
#
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @customer = customers(:one)
  end

  test "on_date returns real time orders created that day" do
    date = DateTime.now - 3.days

    on_before = Order.create!(order_type: "delivery", customer_id: @customer.id, created_at: date - 1.day)
    on_date = Order.create!(order_type: "delivery", customer_id: @customer.id, created_at: date)
    on_after = Order.create!(order_type: "delivery", customer_id: @customer.id, created_at: date + 1.day)

    orders = Order.on_date(date)
    assert orders.size == 1
    assert orders.first.id == on_date.id
  end

  test "on_date returns preorders created for that day" do
    date = DateTime.now - 3.days

    for_before = Order.create!(order_type: "delivery", customer_id: @customer.id, 
      created_at: date - 2.day, for_time: date - 1.day)
    for_date = Order.create!(order_type: "delivery", customer_id: @customer.id, 
      created_at: date - 2.day, for_time: date)
    for_on_date = Order.create!(order_type: "delivery", customer_id: @customer.id, 
      created_at: date.beginning_of_day, for_time: date.end_of_day)
    for_after = Order.create!(order_type: "delivery", customer_id: @customer.id, 
      created_at: date, for_time: date + 1.day)

    orders = Order.on_date(date)
    assert orders.size == 2
    assert orders.find { |o| o.id == for_date.id }.present?
    assert orders.find { |o| o.id == for_on_date.id }.present?
  end

  #TODO: test timezone
end
