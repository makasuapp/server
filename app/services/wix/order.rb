# typed: strict
class Wix::Order
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :id
  sig {returns(T.nilable(DateTime))}
  attr_accessor :submitAt
  sig {returns(T.nilable(Wix::Contact))}
  attr_accessor :contact
  sig {returns(T.nilable(T::Array[Wix::OrderItem]))}
  attr_accessor :orderItems

  sig {returns(DateTime)}
  def submit_at
    T.must(@submitAt)
  end

  sig {returns(T::Array[Wix::OrderItem])}
  def order_items
    T.must(@orderItems)
  end
end