# typed: strict
class Wix::VariationChoice
  extend T::Sig

  sig {void}
  def initialize
    @item_id = T.let("", String)
    @count = T.let(0, Integer)
  end

  sig {returns(String)}
  attr_accessor :item_id
  sig {returns(Integer)}
  attr_accessor :count
  sig {returns(T.nilable(Integer))}
  attr_accessor :price
end