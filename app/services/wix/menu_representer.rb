# typed: false
require 'roar/decorator'
require 'roar/json'

class Wix::MenuRepresenter < Roar::Decorator
  include Roar::JSON

  collection :items, class: Wix::Item do
    property :id
    property :title, class: Wix::LocaleString do
      property :en_CA
      property :en_US
    end
  end
end
