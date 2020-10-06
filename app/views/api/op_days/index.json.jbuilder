json.date_sec @date.to_i

json.inputs do
  json.array!(@inputs) do |day_input|
    json.extract! day_input, :id, :expected_qty, :had_qty, :unit, :inputable_id, :inputable_type
    if day_input.qty_updated_at.present?
      json.qty_updated_at day_input.qty_updated_at.to_i
    end
  end
end

json.prep do
  json.array! @preps do |prep|
    json.extract! prep, :id, :expected_qty, :made_qty, :recipe_step_id
    if prep.min_needed_at.present?
      json.min_needed_at prep.min_needed_at.to_i
    end
    if prep.qty_updated_at.present?
      json.qty_updated_at prep.qty_updated_at.to_i
    end
  end
end

json.predicted_orders do
  json.array! @predicted_orders do |order|
    json.extract! order, :id, :quantity, :recipe_id
    json.date_sec order.date.to_i
  end
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