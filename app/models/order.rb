# typed: false
# == Schema Information
#
# Table name: orders
#
#  id                   :bigint           not null, primary key
#  aasm_state           :string           not null
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
  belongs_to :kitchen
  belongs_to :integration, optional: true
  has_many :order_items

  aasm do
    state :new, initial: true
    state :started
    state :done
    state :delivered

    before_all_events :update_paper_trail

    event :start do
      transitions from: :new, to: :started
      transitions from: :started, to: :started
    end

    event :finish do
      transitions from: :started, to: :done
      transitions from: :done, to: :done
    end

    event :deliver, after: :mark_fulfilled do
      transitions from: :done, to: :delivered
      transitions from: :delivered, to: :delivered
    end
  end

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), timezone: String)
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

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), timezone: String)
    .returns(T.any(Order::ActiveRecord_Relation, Order::ActiveRecord_AssociationRelation))}
  def self.before_date(date, timezone = "America/Toronto")
    date_on = date.in_time_zone(timezone).end_of_day
    self
      .where("for_time < ?", date_on)
      .or(
        self
          .where(for_time: nil)
          .where("created_at < ?", date_on)
      )
  end

  sig {returns(String)}
  def order_id
    self.integration_order_id || self.id.to_s
  end

  sig {returns(String)}
  def topic_name
    "orders_#{self.kitchen_id}"
  end

  sig {void}
  def mark_fulfilled
    if self.integration_id.present?
      integration = self.integration
      if integration.integration_type == IntegrationType::Wix
        # begin
          puts ">>> app: #{integration.wix_app_instance_id} restaurant: #{integration.wix_restaurant_id} order: #{self.integration_order_id}"
          Wix::WixApi.fulfill_order(integration.wix_app_instance_id, 
            integration.wix_restaurant_id, self.integration_order_id)
        # rescue => e
        #   Raven.capture_exception(e)
        # end
      end
    end
  end

  private

  sig {void}
  def update_paper_trail
    self.paper_trail_event = aasm.current_event
  end
end
