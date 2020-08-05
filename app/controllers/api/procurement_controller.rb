# typed: ignore
class Api::ProcurementController < ApplicationController
  def index
    #hacky temp solution to have a dev environment
    if params[:env] == "dev"
      date = OpDay.first.date
    else
      date = Time.now
    end

    @procurement_orders = ProcurementOrder
      .where("for_date >= ?", 
        date.in_time_zone("America/Toronto").beginning_of_day)
      .includes([:vendor, :procurement_items])

    render formats: :json
  end

  def update_items
    latest_updates = {}
    params[:updates].each do |x| 
      id = x[:id] 
      #for now we just take whatever is the last update for the item
      #might want to change it to care about time it came in similar to the others
      latest_updates[id] = x
    end

    items = ProcurementItem.where(id: latest_updates.keys).map do |item|
      update = latest_updates[item.id]

      item.got_qty = update[:got_qty]
      item.got_unit = update[:got_unit]
      item.price_cents = update[:price_cents]
      item.price_unit = update[:price_unit]

      item
    end

    ProcurementItem.import items, on_duplicate_key_update: [:got_qty, :got_unit, :price_cents, :price_unit]

    head :ok
  end
end