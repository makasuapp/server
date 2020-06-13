# typed: true
class GenOpDayJob < ApplicationJob
  def perform(date)
    op_day = OpDay.find_or_create_by!(date: date)
    purchased_recipes = PurchasedRecipe.where(date: date)

    DayIngredient.generate_for(purchased_recipes, op_day)
  end
end
