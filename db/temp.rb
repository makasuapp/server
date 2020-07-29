# typed: strict

date = DateTime.now.in_time_zone("America/Toronto")

op_day = OpDay.find_or_create_by!(date: date)
DayIngredient.where(op_day_id: op_day.id).delete_all
DayPrep.where(op_day_id: op_day.id).delete_all
PurchasedRecipe.where(date: date).delete_all

o = Order.create!(order_type: "pickup", customer_id: 1)
[
  {recipe_id: 37, quantity: 1},
  {recipe_id: 33, quantity: 1},
  {recipe_id: 35, quantity: 4}
].each do |x|
  o.order_items.create!(
    recipe_id: x[:recipe_id], 
    quantity: x[:quantity],
    price_cents: 0
  )
end
PurchasedRecipe.create_from_preorders_for(date.to_date)

v = Vendor.create!(name: "Costco")
po = ProcurementOrder.create!(
  for_date: OpDay.first.date.in_time_zone("America/Toronto").beginning_of_day, 
  order_type: "manual",
  vendor_id: v.id
)
[
  {ingredient_id: 1, quantity: 1},
  {ingredient_id: 2, quantity: 200, unit: "g"},
  {ingredient_id: 6, quantity: 5, unit: "tbsp"}
].each do |x|
  po.procurement_items.create!(
    ingredient_id: x[:ingredient_id], 
    quantity: x[:quantity],
    unit: x[:unit]
  )
end