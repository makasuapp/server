json.extract! recipe, :id, :name, :publish, :unit, :output_qty

json.prep_steps do
  json.array! recipe.recipe_steps
    .select { |step| step.step_type == StepType::Prep }
    .map(&:id)
end

json.cook_steps do
  json.array! recipe.recipe_steps
    .select { |step| step.step_type == StepType::Cook}
    .map(&:id)
end