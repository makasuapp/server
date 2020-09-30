# typed: false
require 'test_helper'

class WixControllerTest < ActionDispatch::IntegrationTest
  setup do
    @o = orders(:delivery)
    @k = kitchens(:test)
  end

  test "order comes in through orders_webhook" do
    orders_count = Order.count

    @k.integrations.create!(
      integration_type: "wix", 
      wix_restaurant_id: "7212040090230996"
    )
    r = recipes(:chicken)

    Firebase.any_instance.expects(:send_notification_with_data).once
    post "/wix/orders", params: {
      "restaurant"=> {
        "type"=>"restaurant", "id"=>"7212040090230996", "created"=>1597952539537, "modified"=>1598204422488, 
        "timezone"=>"America/Toronto", "currency"=>"CAD", "locale"=>"en_CA", "locales"=>["en_CA"]
      }, 
      "menu"=> {
        "modified"=>1598068202210, 
        "items"=> [
          {
            "id"=>"5221e403-e96d-4310-8936-c99373b997f9", "title"=>{"en_CA"=>"Mouth Watering Chicken"}, 
            "description"=>{"en_CA"=>"This is an item on your menu. Give your item a brief description\n"}, 
            "price"=>900, "media"=>{"logo"=>"https://static.wixstatic.com/media/84770f_03f061ddadc747bca8ac653d7cda5f83~mv2_d_1920_1280_s_2.jpg"}
          }, 
          {
            "id"=>"cfb1c583-a782-40f4-b433-e1235e5f8ec1", "title"=>{"en_CA"=>"Yuxiang Eggplant"}, 
            "description"=>{"en_CA"=>"This is an item on your menu. Give your item a brief description\n"}, 
            "price"=>900, "media"=>{"logo"=>"https://static.wixstatic.com/media/84770f_7bdbdd0bf0874051bbcd31ba6cedb6f2~mv2_d_1920_1280_s_2.jpg"}
          }
        ]
      }, 
      "order"=> {
        "id"=>"515217923975", "distributorId"=>"8408044704064049", "restaurantId"=>"7212040090230996", "locale"=>"en_CA", 
        "orderItems"=> [
          {
            "itemId"=>"5221e403-e96d-4310-8936-c99373b997f9", "price"=>900, "count"=>2
          }
        ], "comment"=>"Test comment", "price"=>900, "currency"=>"CAD", 
        "delivery"=> {"type"=>"takeout", "time"=>1599177774327, "timeGuarantee"=>"before"}, 
        "contact"=> {"firstName"=>"Owen", "lastName"=>"Wang", "email"=>"supernuber@gmail.com", "phone"=>"+19197535233"}, 
        "payments"=>[{"type"=>"cashier", "amount"=>900, "paymentMethod"=>"offline", "paymentMethodTitle"=>"Manual", 
          "accountId"=>"13e8d036-5516-6104-b456-c8466db39542:291a232a-1b89-4784-b912-9780a4ea341c"}], 
        "created"=>1599176874327, "modified"=>1599176874327, "status"=>"new", "platform"=>"web"
      }
    }, as: :json

    assert Order.count == orders_count + 1
    order = Order.last
    customer = order.customer
    assert customer.first_name == "Owen"
    assert customer.email == "supernuber@gmail.com"

    assert order.integration_order_id == "515217923975"
    assert order.order_items.length == 1
    assert order.comment == "Test comment"
    order_item = order.order_items.first
    assert order_item.recipe_id == r.id
    assert order_item.quantity == 2
  end
end