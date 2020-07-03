# typed: strict
# == Schema Information
#
# Table name: purchased_recipes
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_purchased_recipes_on_date       (date)
#  index_purchased_recipes_on_recipe_id  (recipe_id)
#
class PurchasedRecipe < ApplicationRecord
  extend T::Sig

  belongs_to :recipe

  sig {params(date: DateTime).void}
  def self.create_from_preorders_for(date)
    #TODO: assumes only preorders, will not be the case later
    PurchasedRecipe.where(date: date).delete_all

    purchased_recipes = []
    Order
      .where(for_time: date.beginning_of_day..date.end_of_day)
      .includes(:order_items)
      .each do |preorder|
      preorder.order_items.each do |oi|
        purchased_recipes << PurchasedRecipe.new(
          date: date, quantity: oi.quantity, recipe_id: oi.recipe_id
        )
      end
    end

    PurchasedRecipe.import! purchased_recipes

    OpDay.update_day_for(date)
  end

  sig {returns(T::Array[IngredientAmount])}
  def ingredient_amounts
    recipe_amounts = self.recipe.ingredient_amounts
    recipe_amounts.map { |amount| amount * self.quantity }
  end
end
