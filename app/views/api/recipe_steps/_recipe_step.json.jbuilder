json.extract! step, :id, :recipe_id, :number, :duration_sec, :instruction, :max_before_sec, :min_before_sec

json.tools(step.tools) do |tool|
  json.extract! tool, :id, :name
end

json.detailed_instructions(step.detailed_instructions) do |instruction|
  json.extract! instruction, :id, :instruction
end

json.inputs(step.inputs) do |input|
  json.extract! input, :id, :inputable_type, :inputable_id, :unit, :quantity
end