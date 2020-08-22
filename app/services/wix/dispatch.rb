# typed: strict
class Wix::Dispatch
  extend T::Sig

  sig {returns(T.nilable(DateTime))}
  attr_accessor :time
end