# typed: strict
class Wix::Menu
  extend T::Sig

  sig {returns(T.nilable(T::Array[Wix::Item]))}
  attr_accessor :items
end