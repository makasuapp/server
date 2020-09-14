# typed: strict
class Wix::Order
  extend T::Sig

  sig {returns(String)}
  attr_accessor :id
  sig {returns(T.nilable(String))}
  attr_accessor :status
  sig {returns(Wix::Dispatch)}
  attr_accessor :delivery
  sig {returns(T.nilable(Wix::Contact))}
  attr_accessor :contact
  sig {returns(T::Array[Wix::OrderItem])}
  attr_accessor :order_items
  sig {returns(T.nilable(String))}
  attr_accessor :comment

  sig {void}
  def initialize
    @id = T.let("", String)
    @order_items = T.let([], T::Array[Wix::OrderItem])
    @delivery = T.let(Wix::Dispatch.new, Wix::Dispatch)
  end

  sig {returns(Time)}
  def for_time
    Time.at(@delivery.time / 1000)
  end
end