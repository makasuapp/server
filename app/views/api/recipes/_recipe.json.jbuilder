json.extract! recipe, :id, :name, :publish, :unit, :output_qty, :volume_weight_ratio

json.prep_step_ids do
  json.array! recipe.recipe_steps
    .select { |step| step.step_type == StepType::Prep }
    .map(&:id)
end

json.cook_step_ids do
  json.array! recipe.recipe_steps
    .select { |step| step.step_type == StepType::Cook}
    .map(&:id)
end