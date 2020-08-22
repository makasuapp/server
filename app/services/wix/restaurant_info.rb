# typed: strict
class Wix::RestaurantInfo
  extend T::Sig

  sig {returns(T.nilable(Wix::Menu))}
  attr_accessor :menu
end
