json.ingredients do
  json.array!(@ingredients) do |ingredient|
    json.extract! ingredient, :id, :expected_qty, :had_qty, :unit
    json.name ingredient.ingredient.name
    if ingredient.qty_updated_at.present?
      json.qty_updated_at ingredient.qty_updated_at.to_i
    end
  end
end

json.prep do
  json.array! @preps do |prep|
    json.extract! prep, :id, :expected_qty, :made_qty, :recipe_step_id
    if prep.qty_updated_at.present?
      json.qty_updated_at prep.qty_updated_at.to_i
    end
  end
end

json.optional do
  json.ingredients do
    # json.array! @optional_ingredients, partial: "api/op_days/day_ingredients", as: :ingredient
  end

  json.prep do
    # json.array! @optional_prep, partial: "api/op_days/day_prep", as: :prep
  end
end