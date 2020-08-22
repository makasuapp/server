require 'roar/decorator'
require 'roar/json'
require 'roar/coercion'
  
class Wix::OrderRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::Coercion

  property :id
  property :submitAt, type: DateTime

  property :contact, class: Wix::Contact do
    property :firstName
    property :lastName
    property :email
    property :phone
  end

  collection :orderItems, class: Wix::OrderItem do
    property :itemId
    property :count
    property :price
  end
end