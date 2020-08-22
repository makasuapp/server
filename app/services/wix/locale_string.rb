# typed: strict
class Wix::LocaleString
  extend T::Sig

  sig {returns(T.nilable(String))}
  attr_accessor :en_CA
  sig {returns(T.nilable(String))}
  attr_accessor :en_US

  sig {returns(String)}
  def default
    T.must(@en_CA || @en_US)
  end
end