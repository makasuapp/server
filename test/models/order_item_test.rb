# typed: strict
# == Schema Information
#
# Table name: order_items
#
#  id          :bigint           not null, primary key
#  done_at     :datetime
#  price_cents :integer          not null
#  quantity    :integer          not null
#  started_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  order_id    :bigint           not null
#  recipe_id   :bigint           not null
#
# Indexes
#
#  index_order_items_on_order_id   (order_id)
#  index_order_items_on_recipe_id  (recipe_id)
#
require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
