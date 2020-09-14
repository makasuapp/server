# typed: strict
class Wix::OrderItem
  extend T::Sig

  sig {void}
  def initialize
    @item_id = T.let("", String)
    @count = T.let(0, Integer)
    @price = T.let(0, Integer)
  end

  sig {returns(String)}
  attr_accessor :item_id
  sig {returns(Integer)}
  attr_accessor :count
  sig {returns(Integer)}
  attr_accessor :price
  sig {returns(T.nilable(String))}
  attr_accessor :comment
  sig {returns(T.nilable(T::Array[Wix::Variation]))}
  attr_accessor :variations
  sig {returns(T.nilable(T::Array[T::Array[Wix::VariationChoice]]))}
  attr_accessor :variationsChoices
end