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

organization = Organization.find_or_create_by(name: "Test")
kitchen.update_attributes(organization_id: organization.id)
user = User.first
UserOrganization.create!(organization_id: organization.id, user_id: T.must(user).id, role: "owner")
Recipe.update_all(organization_id: organization.id)