json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :expected_qty, :had_qty, :unit
  json.name ingredient.ingredient.name
end