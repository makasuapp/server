json.orders do
  json.array! @orders, partial: "api/orders/order", as: :order
end

json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.recipe_steps do
  json.array! @recipe_steps, partial: "api/recipe_steps/recipe_step", as: :step
end

json.ingredients do
  json.array! @ingredients, partial: "api/ingredients/ingredient", as: :ingredient
end