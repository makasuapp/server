# typed: strict
# == Schema Information
#
# Table name: predicted_orders
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint           not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_predicted_orders_on_date                 (date)
#  index_predicted_orders_on_date_and_kitchen_id  (date,kitchen_id)
#  index_predicted_orders_on_recipe_id            (recipe_id)
#
class PredictedOrder < ApplicationRecord
  extend T::Sig

  validate :recipe_can_purchase

  belongs_to :recipe
  belongs_to :kitchen

  sig {void}
  def recipe_can_purchase
    if self.recipe.unit.present?
      errors.add(:recipe_id, "must be for a recipe that doesn't have units")
    end
  end

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), kitchen: Kitchen).void}
  def self.create_from_preorders_for(date, kitchen)
    #TODO: assumes only preorders, will not be the case later
    PredictedOrder.where(date: date, kitchen_id: kitchen.id).delete_all

    predicted_orders = []
    #TODO(timezone)
    Order
      .where(kitchen_id: kitchen.id)
      .on_date(date, "America/Toronto")
      .includes(:order_items)
      .each do |preorder|
      preorder.order_items.each do |oi|
        predicted_orders << PredictedOrder.new(
          date: date, quantity: oi.quantity, recipe_id: oi.recipe_id, kitchen_id: kitchen.id
        )
      end
    end

    PredictedOrder.import! predicted_orders

    OpDay.update_day_for(date, kitchen)
  end

  sig {returns(T::Array[IngredientAmount])}
  def ingredient_amounts
    recipe = self.recipe
    recipe_amounts = recipe.ingredient_amounts
    recipe_servings = recipe.servings_produced(self.quantity)

    recipe_amounts.map { |amount| amount * recipe_servings }
  end
end
