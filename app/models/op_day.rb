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
  has_many :day_ingredients, dependent: :delete_all
  has_many :day_preps, dependent: :delete_all
end
