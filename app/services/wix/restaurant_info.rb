# typed: strict
class Wix::RestaurantInfo
  extend T::Sig

  sig {void}
  def initialize
    @menu = T.let(Wix::Menu.new, Wix::Menu)
    @id = T.let("", String)
  end

  sig {returns(Wix::Menu)}
  attr_accessor :menu
  sig {returns(String)}
  attr_accessor :id
end
