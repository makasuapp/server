# typed: strict
class Wix::OrderItem
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :itemId
  sig {returns(T.nilable(Integer))}
  attr_accessor :count
  sig {returns(T.nilable(Integer))}
  attr_accessor :price

  sig {returns(String)}
  def item_id
    T.must(@itemId)
  end
end