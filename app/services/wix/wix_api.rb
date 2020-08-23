# typed: false

require 'http'

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

      url = "#{API_URL}/organizations/#{wix_restaurant_id}/orders/#{wix_order_id}?viewMode=restaurant"
      resp = HTTP.auth("Bearer #{auth_token}").get(url).body.to_s
      json = JSON.parse(resp).to_json

      Wix::OrderRepresenter.new(Wix::Order.new).from_json(json)
    end

    sig {params(wix_app_instance_id: String, wix_restaurant_id: String, 
      wix_order_id: String).returns(Wix::Order)}
    def self.fulfill_order(wix_app_instance_id, wix_restaurant_id, wix_order_id)
      auth_token = self.get_access_token(wix_app_instance_id)

      url = "#{API_URL}/organizations/#{wix_restaurant_id}/orders/#{wix_order_id}/properties"
      resp = HTTP.auth("Bearer #{auth_token}").put(url, json: {"com.wix.restaurants": "{\"delivered\": true}"}).body.to_s
      json = JSON.parse(resp).to_json

      Wix::OrderRepresenter.new(Wix::Order.new).from_json(json)
    end

    sig {params(wix_restaurant_id: String).returns(Wix::RestaurantInfo)}
    def self.get_restaurant_info(wix_restaurant_id)
      url = "#{API_URL}/organizations/#{wix_restaurant_id}/full"
      resp = HTTP.get(url).body.to_s
      json = JSON.parse(resp).to_json

      Wix::RestaurantRepresenter.new(Wix::RestaurantInfo.new).from_json(json)
    end
  end
end