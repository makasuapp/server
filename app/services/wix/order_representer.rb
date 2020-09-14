# typed: false
require 'roar/decorator'
require 'roar/json'
  
class Wix::OrderRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :status
  property :comment

  property :delivery, class: Wix::Dispatch do
    property :time
    property :type
  end

  property :contact, class: Wix::Contact do
    property :first_name, as: :firstName
    property :last_name, as: :lastName
    property :email
    property :phone
  end

  collection :order_items, as: :orderItems, class: Wix::OrderItem do
    property :item_id, as: :itemId
    property :count
    property :price
    property :comment

    collection :variations, class: Wix::Variation do
      collection :item_ids, as: :itemIds
      property :prices
      property :display_type, as: :displayType
      property :title, class: Wix::LocaleString do
        property :en_CA
        property :en_US
      end
    end

    collection :variationsChoices
  end
end