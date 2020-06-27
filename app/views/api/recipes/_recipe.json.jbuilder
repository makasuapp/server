json.extract! recipe, :id, :name, :publish, :unit, :output_qty

json.prep_steps do
  json.array! recipe.recipe_steps.includes([:inputs, :detailed_instructions, :tools])
    .select { |step| step.step_type == StepType::Prep }, partial: "api/recipe_steps/recipe_step", as: :step
end

json.cook_steps do
  json.array! recipe.recipe_steps.includes([:inputs, :detailed_instructions, :tools])
    .select { |step| step.step_type == StepType::Cook}, partial: "api/recipe_steps/recipe_step", as: :step
end