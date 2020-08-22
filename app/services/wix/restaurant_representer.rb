require 'roar/decorator'
require 'roar/json'

class Wix::RestaurantRepresenter < Roar::Decorator
  include Roar::JSON

  property :id

  property :menu, class: Wix::Menu, decorator: Wix::MenuRepresenter
end