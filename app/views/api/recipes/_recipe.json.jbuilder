json.extract! recipe, :id, :name, :publish, :output_quantity, :unit

json.prep_steps(recipe.prep_steps) do |step|
  json.extract! step, :id, :number, :duration_sec, :instruction, :max_before_sec, :min_before_sec

  json.tools(step.tools) do |tool|
    json.extract! tool, :id, :name
  end

  json.detailed_instructions(step.detailed_instructions) do |instruction|
    json.extract! instruction, :id, :instruction
  end

  json.inputs(step.inputs) do |input|
    json.extract! input, :id, :inputable_type, :inputable_id, :quantity, :unit

    if input.inputable_type == "Ingredient"
      json.name input.inputable.name
    end 
  end
end

json.cook_steps(recipe.cook_steps) do |step|
  json.extract! step, :id, :number, :duration_sec, :instruction, :max_before_sec, :min_before_sec

  json.tools(step.tools) do |tool|
    json.extract! tool, :id, :name
  end

  json.detailed_instructions(step.detailed_instructions) do |instruction|
    json.extract! instruction, :id, :instruction
  end
  
  json.inputs(step.inputs) do |input|
    json.extract! input, :id, :inputable_type, :inputable_id, :quantity, :unit

    if input.inputable_type == "Ingredient"
      json.name input.inputable.name
    end 
  end
end