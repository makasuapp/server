# typed: strict
class Wix::Item
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :id
  sig {returns(T.nilable(Wix::LocaleString))}
  attr_accessor :title

  sig {returns(String)}
  def name
    @title.default
  end
end