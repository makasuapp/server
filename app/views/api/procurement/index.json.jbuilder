json.array!(@procurement_orders) do |order|
  json.extract! order, :id, :order_type
  json.vendor_name order.vendor.name
  json.for_date order.for_date.to_i

  json.items do 
    json.array!(order.procurement_items) do |pi|
      json.extract! pi, :id, :ingredient_id, :quantity, :unit, :got_qty, :got_unit, :price_cents, :price_unit
    end
  end
end