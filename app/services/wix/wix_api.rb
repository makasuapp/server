# typed: false

require 'http'
require 'roar/decorator'
require 'roar/json'
require 'roar/coercion'

module Wix
  class WixApi
    extend T::Sig

    API_URL = "https://api.wixrestaurants.com/v2"    
    AUTH_URL = "https://auth.wixrestaurants.com/v2"

    sig {params(wix_app_instance_id: String).returns(String)}
    def self.get_access_token(wix_app_instance_id)
      url = "#{AUTH_URL}/com.wix/access_token"
      resp = HTTP.post(url, json: {instance: wix_app_instance_id}).body.to_s
      json = JSON.parse(resp)

      json["accessToken"]
    end

    sig {params(wix_app_instance_id: String, wix_restaurant_id: String, 
      wix_order_id: String).returns(Wix::Order)}
    def self.get_order(wix_app_instance_id, wix_restaurant_id, wix_order_id)
      auth_token = self.get_access_token(wix_app_instance_id)

      url = "#{API_URL}/organizations/#{wix_restaurant_id}/orders/#{wix_order_id}"
      #TODO(wix): is this right?
      resp = HTTP.auth("Token #{auth_token}").get(url).body.to_s
      json = JSON.parse(resp).to_json

      OrderRepresenter.new(Wix::Order.new).from_json(json)
    end

    sig {params(wix_restaurant_id: String).returns(Wix::RestaurantInfo)}
    def self.get_restaurant_info(wix_restaurant_id)
      url = "#{API_URL}/organizations/#{wix_restaurant_id}/full"
      resp = HTTP.get(url).body.to_s
      json = JSON.parse(resp).to_json

      RestaurantInfoRepresenter.new(Wix::RestaurantInfo.new).from_json(json)
    end
  end

  class OrderRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

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

  class RestaurantInfoRepresenter < Roar::Decorator
    include Roar::JSON

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
end