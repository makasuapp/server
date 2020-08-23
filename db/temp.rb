# typed: strict

kitchen = Kitchen.find_or_create_by(name: "Test")
date = DateTime.now.in_time_zone("America/Toronto")

op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)
DayIngredient.where(op_day_id: op_day.id).delete_all
DayPrep.where(op_day_id: op_day.id).delete_all
PredictedOrder.where(date: date, kitchen_id: kitchen.id).delete_all

o = Order.create!(order_type: "pickup", customer_id: 1, kitchen_id: kitchen.id)
[
  {recipe_id: 37, quantity: 1},
  {recipe_id: 33, quantity: 1},
  {recipe_id: 35, quantity: 1}
].each do |x|
  o.order_items.create!(
    recipe_id: x[:recipe_id], 
    quantity: x[:quantity],
    price_cents: 0
  )
end
PredictedOrder.create_from_preorders_for(date.to_date, kitchen)

v = Vendor.create!(name: "T&T")
day_ingredients = DayIngredient.where(op_day_id: op_day.id)
ProcurementOrder.create_from(day_ingredients, v, date, kitchen)

OpDay.update_all(kitchen_id: kitchen.id)
Order.update_all(kitchen_id: kitchen.id)
ProcurementOrder.update_all(kitchen_id: kitchen.id)
PredictedOrder.update_all(kitchen_id: kitchen.id)
Recipe.update_all(kitchen_id: kitchen.id)

kitchen.integrations.create!(integration_type: "wix", wix_restaurant_id: "252491363672592")