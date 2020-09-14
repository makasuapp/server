# typed: strict
class Wix::Variation
  extend T::Sig

  sig {void}
  def initialize
    @item_ids = T.let([], T::Array[String])
    @display_type = T.let("", String)
    @title = T.let(Wix::LocaleString.new, Wix::LocaleString)
  end

  sig {returns(T::Array[String])}
  attr_accessor :item_ids
  sig {returns(T.nilable(T::Hash[String, Integer]))}
  attr_accessor :prices
  sig {returns(String)}
  attr_accessor :display_type

  sig {returns(Wix::LocaleString)}
  attr_accessor :title

  sig {returns(String)}
  def name
    @title.default
  end

  sig {returns(T::Boolean)}
  def is_addon
    @display_type == "choice"
  end

  sig {returns(T::Boolean)}
  def is_removal
    @display_type == "diff"
  end
end