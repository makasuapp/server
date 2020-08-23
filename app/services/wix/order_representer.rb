require 'roar/decorator'
require 'roar/json'
  
class Wix::OrderRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :status

  property :delivery, class: Wix::Dispatch do
    property :time
    property :type
  end

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