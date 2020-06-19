json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :expected_qty, :had_qty, :unit
  json.name ingredient.ingredient.name
  json.qty_updated_at ingredient.qty_updated_at.to_i
end