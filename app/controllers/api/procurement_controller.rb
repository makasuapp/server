# typed: ignore
class Api::ProcurementController < ApplicationController
  def index
    date = Time.now

    @procurement_orders = ProcurementOrder
      .where(kitchen_id: params[:kitchen_id])
      .where("for_date >= ?", 
        date.in_time_zone("America/Toronto").beginning_of_day)
      .includes([:vendor, :procurement_items])

    render formats: :json
  end

  def costs
    #TODO(cache): cache this entire fragment

    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @recipes = Recipe.where(organization_id: @kitchen.organization_id)
    @ingredients = Ingredient.where(organization_id: @kitchen.organization_id)
    @recipe_steps = RecipeStep
      .where(recipe_id: @recipes.map(&:id), removed: false)
      .includes([{inputs: :inputable}, :detailed_instructions, :tools, :recipe])

    @costs = ProcurementItem
      .where(ingredient_id: @ingredients.map(&:id))
      .where(latest_price: true)
      .where.not(price_cents: nil)
      .order("updated_at DESC")
  end

  def create_cost
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @item = ProcurementItem.new(procurement_item_params)
    @item.quantity = @item.got_qty
    @item.unit = @item.got_unit
    @item.latest_price = true

    #TODO(recipe_cost): set old price of same unit to latest=false

    unless @item.save
      render json: @item.errors, status: :unprocessable_entity
      return
    end

    head :ok
  end

  def update_items
    #TODO(recipe_cost): build map of latest priced procurement items

    latest_updates = {}
    params[:updates].each do |x| 
      id = x[:id] 
      #for now we just take whatever is the last update for the item
      #might want to change it to care about time it came in similar to the others
      latest_updates[id] = x
    end

    items = []
    ProcurementItem.where(id: latest_updates.keys).each do |item|
      update = latest_updates[item.id]

      item.got_qty = update[:got_qty]
      item.got_unit = update[:got_unit]
      item.price_cents = update[:price_cents]

      #TODO(recipe_cost): if price is not nil and is more recent than latest priced procurement item,
      #update this latest_price=true, the other to false 
      #what do about edge case where setting price to nil and is latest?

      items << item
    end

    ProcurementItem.import items, on_duplicate_key_update: [:got_qty, :got_unit, :price_cents]

    head :ok
  end

  private

  def procurement_item_params
    params.require(:procurement_item).permit(:price_cents, :ingredient_id, :got_qty, :got_unit)
  end
end