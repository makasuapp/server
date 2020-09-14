# typed: false
require 'roar/decorator'
require 'roar/json'
require 'representable/json/collection'

class Wix::VariationChoiceRepresenter < Roar::Decorator
  include Roar::JSON
  include Representable::JSON::Collection

  items class: Wix::VariationChoice do
    property :item_id, as: :itemId
    property :count
    property :price
  end
end
