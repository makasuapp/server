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

  # after_save :update_op_day
  # after_destroy :update_op_day

  belongs_to :recipe

  #TODO: this assumes we won't update any recipes after already started checking them. not the greatest
  sig {void}
  def update_op_day
    op_day = OpDay.find_or_create_by!(date: self.date)

    #clear existing
    op_day.day_ingredients.delete_all
    op_day.day_preps.delete_all

    #regenerate for all recipes of that date - this ensures we capture both additions and subtractions
    purchased_recipes = PurchasedRecipe.where(date: self.date)
    DayIngredient.generate_for(purchased_recipes, op_day)
    DayPrep.generate_for(purchased_recipes, op_day)
  end

  sig {returns(T::Array[IngredientAmount])}
  def ingredient_amounts
    recipe_amounts = self.recipe.ingredient_amounts
    recipe_amounts.map { |amount| amount * self.quantity }
  end
end
