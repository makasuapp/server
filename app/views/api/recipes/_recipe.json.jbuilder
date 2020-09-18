json.extract! recipe, :id, :name, :publish, :unit, :output_qty, :volume_weight_ratio

json.step_ids do
  json.array! recipe.recipe_steps
    .sort_by { |step| step.number }
    .map(&:id)
end