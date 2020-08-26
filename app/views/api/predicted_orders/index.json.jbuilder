json.array!(@predicted_orders) do |order|
  json.extract! order, :id, :date, :quantity, :recipe_id
  json.name order.recipe.name
end