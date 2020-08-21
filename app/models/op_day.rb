# typed: strict
# == Schema Information
#
# Table name: op_days
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint
#
# Indexes
#
#  index_op_days_on_date                 (date)
#  index_op_days_on_date_and_kitchen_id  (date,kitchen_id)
#
class OpDay < ApplicationRecord
  extend T::Sig

  belongs_to :kitchen
  has_many :day_ingredients, dependent: :delete_all
  has_many :day_preps, dependent: :delete_all

  sig {params(date: T.any(DateTime, Date, ActiveSupport::TimeWithZone), kitchen: Kitchen).void}
  def self.update_day_for(date, kitchen)
    op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)

    #clear existing
    op_day.day_ingredients.delete_all
    op_day.day_preps.delete_all

    #regenerate for all recipes of that date - this ensures we capture both additions and subtractions
    purchased_recipes = PurchasedRecipe.where(date: date, kitchen_id: kitchen.id)
    DayIngredient.generate_for(purchased_recipes, op_day)
    DayPrep.generate_for(purchased_recipes, op_day)
  end
end
