json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.ingredients do
  json.array!(@ingredients) do |ingredient|
    json.extract! ingredient, :id, :name, :volume_weight_ratio
  end
end