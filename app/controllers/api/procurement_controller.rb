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

  #think about what's a better way to update price across units
  #if we don't do it that way, then they have to know to manually update the price of a specific thing
  #e.g. if bought 1 of something, have to manually create separate price for g of it
  def create_cost
    @kitchen = Kitchen.find_by(id: params[:kitchen_id])

    @item = ProcurementItem.new(procurement_item_params)
    @item.quantity = @item.got_qty
    @item.unit = @item.got_unit
    @item.latest_price = true

    old_items = ProcurementItem.where(
      ingredient_id: @item.ingredient_id,
      latest_price: true
    )

    unless @item.save
      render json: @item.errors, status: :unprocessable_entity
      return
    end

    old_items.each do |old_item|
      ingredient = Ingredient.find(old_item.ingredient_id)
      if @item.id != old_item.id && 
        UnitConverter.can_convert?(@item.unit, old_item.unit, ingredient.volume_weight_ratio)
        old_item.update_attributes!(latest_price: false)
      end
    end

    head :ok
  end

  def update_items
    old_items = {}
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
      items << item

      #what do about edge case where setting price to nil and is latest?
      if item.price_cents.present?
        old_items = ProcurementItem.where(
          ingredient_id: item.ingredient_id,
          latest_price: true
        )

        old_items.each do |old_item|
          ingredient = Ingredient.find(old_item.ingredient_id)
          if item.id != old_item.id && 
            UnitConverter.can_convert?(item.unit, old_item.unit, ingredient.volume_weight_ratio)
            old_item.latest_price = false
            items << old_item
          end
        end
      end
    end

    ProcurementItem.import items, on_duplicate_key_update: [:got_qty, :got_unit, :price_cents, :latest_price]

    head :ok
  end

  private

  def procurement_item_params
    params.require(:procurement_item).permit(:price_cents, :ingredient_id, :got_qty, :got_unit)
  end
end