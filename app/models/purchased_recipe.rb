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

  sig {returns(T::Array[IngredientAmount])}
  def ingredient_amounts
    recipe_amounts = self.recipe.ingredient_amounts
    recipe_amounts.map { |amount| amount * self.quantity }
  end
end
