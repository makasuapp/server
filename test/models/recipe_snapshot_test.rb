# == Schema Information
#
# Table name: recipe_snapshots
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  output_qty :float            not null
#  unit       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_recipe_snapshots_on_recipe_id  (recipe_id)
#
require 'test_helper'

class RecipeSnapshotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
