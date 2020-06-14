# typed: false

require 'test_helper'

class UnitConverterTest < ActiveSupport::TestCase
  test "convert with no units just returns qty" do
    assert UnitConverter.convert(1.5) == 1.5
  end

  test "convert with one unit errors" do
    assert_raises RuntimeError do
      UnitConverter.convert(1.5, nil, "grams")
    end

    assert_raises RuntimeError do
      UnitConverter.convert(1.5, "grams")
    end
  end

  test "convert of different unit" do
    #TODO(unit_conversion)
  end

  test "unit_matches?=true when both nil" do
    assert UnitConverter.unit_matches?(nil, nil)
  end

  test "unit_matches?=true when both units" do
    assert UnitConverter.unit_matches?("tablespoons", "tablespoons")
  end

  test "unit_matches?=false when one has units and other doesn't" do
    assert !UnitConverter.unit_matches?("tablespoons", nil)
    assert !UnitConverter.unit_matches?(nil, "tablespoons")
  end
end