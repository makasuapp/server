# typed: false
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
module OrderType
  Delivery = "delivery"
  Pickup = "pickup"
end

#TODO: figure out typing situation for paper trail and aasm
class Order < ApplicationRecord
  extend T::Sig
  include AASM

  validates :order_type, inclusion: { in: %w(delivery pickup), message: "%{value} is not a valid type" }

  has_paper_trail versions: {
    class_name: 'Order::Version'
  }

  belongs_to :customer
  has_many :order_items

  aasm do
    state :new, initial: true
    state :started
    state :done
    state :delivered

    before_all_events :update_paper_trail

    event :start do
      transitions from: :new, to: :started
    end

    event :finish do
      transitions from: :started, to: :done
    end

    event :deliver do
      transitions from: :done, to: :delivered
    end
  end

  sig {params(date: T.any(DateTime, Date), timezone: String)
    .returns(T.any(Order::ActiveRecord_Relation, Order::ActiveRecord_AssociationRelation))}
  def self.on_date(date, timezone = "America/Toronto")
    date_on = date.in_time_zone(timezone)
    self
      .where(for_time: date_on.beginning_of_day..date_on.end_of_day)
      .or(
        self
          .where(for_time: nil)
          .where(created_at: date_on.beginning_of_day..date_on.end_of_day)
      )
  end

  private

  sig {void}
  def update_paper_trail
    self.paper_trail_event = aasm.current_event
  end
end
