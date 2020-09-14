# typed: strict
class Wix::MenuItem
  extend T::Sig

  sig {returns(String)}
  attr_accessor :id
  sig {returns(Wix::LocaleString)}
  attr_accessor :title

  sig {void}
  def initialize
    @id = T.let("", String)
    @title = T.let(Wix::LocaleString.new, Wix::LocaleString)
  end

  sig {returns(String)}
  def name
    @title.default
  end
end