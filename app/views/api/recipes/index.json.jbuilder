json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.ingredients do
  json.array! @ingredients, partial: "api/ingredients/ingredient", as: :ingredient
end