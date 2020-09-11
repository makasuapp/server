# typed: strict
# == Schema Information
#
# Table name: op_days
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :bigint           not null
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
end
