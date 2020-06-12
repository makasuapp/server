# typed: strict
# == Schema Information
#
# Table name: purchased_recipes
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint
#
# Indexes
#
#  index_purchased_recipes_on_date       (date)
#  index_purchased_recipes_on_recipe_id  (recipe_id)
#
require 'test_helper'

class PurchasedRecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
