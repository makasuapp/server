json.orders do
  json.array!(@orders) do |order|
    json.extract! order, :id, :for_time, :created_at, :order_type
    json.state order.aasm_state

    json.customer do
      json.extract! order.customer, :id, :email, :name, :phone_number
    end

    json.items do 
      json.array!(order.order_items) do |oi|
        json.extract! oi, :id, :recipe_id, :price_cents, :quantity, :started_at, :done_at
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