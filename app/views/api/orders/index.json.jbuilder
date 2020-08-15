json.orders do
  json.array! @orders, partial: "api/orders/order", as: :order
  end
end

json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.recipe_steps do
  json.array! @recipe_steps, partial: "api/recipe_steps/recipe_step", as: :step
end

json.ingredients do
  json.array!(@ingredients) do |ingredient|
    json.extract! ingredient, :id, :name, :volume_weight_ratio
  end
end