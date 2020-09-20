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
