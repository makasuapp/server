json.extract! recipe, :id, :name, :publish, :unit, :output_qty, :volume_weight_ratio, :current_price_cents

json.step_ids do
  json.array! recipe.recipe_steps.latest.order("number ASC")
    .map(&:id)
end