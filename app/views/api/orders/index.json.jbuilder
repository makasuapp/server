json.orders do
  json.array!(@orders) do |order|
    json.extract! order, :id, :order_type
    json.created_at order.created_at.to_i
    if order.for_time.present?
      json.for_time order.for_time.to_i
    end
    json.state order.aasm_state

    json.customer do
      json.extract! order.customer, :id, :email, :name, :phone_number
    end

    json.items do 
      json.array!(order.order_items) do |oi|
        json.extract! oi, :id, :recipe_id, :price_cents, :quantity

        if oi.started_at.present?
          json.started_at oi.started_at.to_i
        end

        if oi.done_at.present?
          json.done_at oi.done_at.to_i
        end
      end
    end
  end
end

json.recipes do
  json.array! @recipes, partial: "api/recipes/recipe", as: :recipe
end

json.recipe_steps do
  json.array! @recipe_steps, partial: "api/recipe_steps/recipe_step", as: :step
end