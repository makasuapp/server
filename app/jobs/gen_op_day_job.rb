# typed: false

class GenOpDayJob < ApplicationJob
  queue_as :default

  def perform(date)
    op_day = OpDay.find_or_create!(date: date)
    purchased_recipes = PurchasedRecipe.where(date: date)
  end
end
