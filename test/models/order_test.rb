# typed: false
# == Schema Information
#
# Table name: orders
#
#  id                   :bigint           not null, primary key
#  aasm_state           :string           not null
#  comment              :string
#  confirmed_at         :datetime
#  for_time             :datetime
#  order_type           :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :bigint           not null
#  integration_id       :bigint
#  integration_order_id :string
#  kitchen_id           :bigint           not null
#
# Indexes
#
#  idx_kitchen_time                                         (kitchen_id,for_time,created_at,aasm_state)
#  index_orders_on_customer_id                              (customer_id)
#  index_orders_on_integration_id_and_integration_order_id  (integration_id,integration_order_id)
#
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @customer = customers(:one)
    @kitchen = kitchens(:test)
  end

  def mk_order(created_at, for_time = nil)
    Order.create!(order_type: "delivery", customer_id: @customer.id, kitchen_id: @kitchen.id,
      created_at: created_at, for_time: for_time)
  end

  test "on_date returns real time orders created that day" do
    date = DateTime.now - 3.days

    on_before = mk_order(date - 1.day)
    on_date = mk_order(date)
    on_after = mk_order(date + 1.day)

    orders = Order.on_date(date)
    assert orders.size == 1
    assert orders.first.id == on_date.id
  end

  test "on_date returns preorders created for that day" do
    date = DateTime.now - 3.days

    for_before = mk_order(date - 2.day, date - 1.day)
    for_date = mk_order(date - 2.day, date)
    for_on_date = mk_order(date.beginning_of_day, date.end_of_day)
    for_after = mk_order(date, date + 1.day)

    orders = Order.on_date(date)
    assert orders.size == 2
    assert orders.find { |o| o.id == for_date.id }.present?
    assert orders.find { |o| o.id == for_on_date.id }.present?
  end

  #TODO: test timezone
end
