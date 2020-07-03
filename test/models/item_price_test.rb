# typed: strict
# == Schema Information
#
# Table name: item_prices
#
#  id          :bigint           not null, primary key
#  price_cents :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :bigint
#
# Indexes
#
#  index_item_prices_on_recipe_id  (recipe_id)
#
require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
