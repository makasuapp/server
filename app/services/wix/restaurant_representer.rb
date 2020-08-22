require 'roar/decorator'
require 'roar/json'

class Wix::RestaurantRepresenter < Roar::Decorator
  include Roar::JSON

  property :id

  property :menu, class: Wix::Menu do
    collection :items, class: Wix::Item do
      property :id
      property :title, class: Wix::LocaleString do
        property :en_CA
        property :en_US
      end
    end
  end
end