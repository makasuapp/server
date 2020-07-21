# typed: strict

date = DateTime.now

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
PurchasedRecipe.create_from_preorders_for(date)