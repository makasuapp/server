# typed: strict
class Wix::Menu
  extend T::Sig

  sig {void}
  def initialize
    @items = T.let([], T::Array[Wix::MenuItem])
  end

  sig {returns(T::Array[Wix::MenuItem])}
  attr_accessor :items
end