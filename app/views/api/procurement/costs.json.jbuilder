json.costs do
  json.array!(@costs) do |pi|
    json.extract! pi, :id, :ingredient_id, :got_qty, :got_unit, :price_cents
    json.updated_at_sec pi.update_at.to_i
  end
end

json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.ingredients do
  json.array! @ingredients, partial: "api/ingredients/ingredient", as: :ingredient
end

json.recipe_steps do
  json.array! @recipe_steps, partial: "api/recipe_steps/recipe_step", as: :step
end