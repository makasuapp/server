# typed: strict
# == Schema Information
#
# Table name: kitchens
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#
require 'test_helper'

class KitchenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
