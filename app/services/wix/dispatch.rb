# typed: strict
class Wix::Dispatch
  extend T::Sig

  sig {returns(T.nilable(Integer))}
  attr_accessor :time
  sig {returns(T.nilable(String))}
  attr_accessor :type
end