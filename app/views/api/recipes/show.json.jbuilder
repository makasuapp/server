json.recipe do
  json.partial! "api/recipes/recipe", recipe: @recipe
end

json.recipe_steps do
  json.array! @recipe_steps, partial: "api/recipe_steps/recipe_step", as: :step
end