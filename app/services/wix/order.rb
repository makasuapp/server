# typed: strict
class Wix::Order
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :id
  sig {returns(T.nilable(String))}
  attr_accessor :status
  sig {returns(T.nilable(Wix::Dispatch))}
  attr_accessor :delivery
  sig {returns(T.nilable(Wix::Contact))}
  attr_accessor :contact
  sig {returns(T.nilable(T::Array[Wix::OrderItem]))}
  attr_accessor :orderItems

  sig {returns(Time)}
  def for_time
    Time.at(T.must(T.must(@delivery).time) / 1000)
  end

  sig {returns(T::Array[Wix::OrderItem])}
  def order_items
    T.must(@orderItems)
  end
end