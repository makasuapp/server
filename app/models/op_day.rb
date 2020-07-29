# typed: strict
# == Schema Information
#
# Table name: op_days
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_op_days_on_date  (date)
#
class OpDay < ApplicationRecord
  extend T::Sig

  has_many :day_ingredients, dependent: :delete_all
  has_many :day_preps, dependent: :delete_all

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone)).void}
  def self.update_day_for(date)
    op_day = OpDay.find_or_create_by!(date: date)

    #clear existing
    op_day.day_ingredients.delete_all
    op_day.day_preps.delete_all

    #regenerate for all recipes of that date - this ensures we capture both additions and subtractions
    purchased_recipes = PurchasedRecipe.where(date: date)
    DayIngredient.generate_for(purchased_recipes, op_day)
    DayPrep.generate_for(purchased_recipes, op_day)
  end
end
