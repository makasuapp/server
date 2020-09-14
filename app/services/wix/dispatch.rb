# typed: strict
class Wix::Dispatch
  extend T::Sig

  sig {void}
  def initialize
    @time = T.let(0, Integer)
    @type = T.let("", String)
  end

  sig {returns(Integer)}
  attr_accessor :time
  sig {returns(String)}
  attr_accessor :type
end