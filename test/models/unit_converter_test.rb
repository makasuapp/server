# typed: false

require 'test_helper'

class UnitConverterTest < ActiveSupport::TestCase
  test "convert with no units just returns qty" do
    assert UnitConverter.convert(1.5) == 1.5
  end

  test "convert with one unit errors" do
    assert_raises RuntimeError do
      UnitConverter.convert(1.5, nil, "g")
    end

    assert_raises RuntimeError do
      UnitConverter.convert(1.5, "g")
    end
  end

  test "convert of weight" do
    assert UnitConverter.convert(12, "oz", "lb") == 0.75
  end

  test "convert of volume" do
    assert UnitConverter.convert(1.5, "tbsp", "tsp") == 4.5
  end

  test "convert of volume to weight" do
    assert UnitConverter.convert(2, "gal", "kg", 1.5) == 11.355
  end

  test "convert of weight to volume" do
    assert UnitConverter.convert(15, "lb", "L", 1.4) == 4.86
  end

  test "can_convert?=true when both nil" do
    assert UnitConverter.can_convert?(nil, nil)
  end

  test "can_convert?=true when both not weight/volume" do
    assert UnitConverter.can_convert?("handful", "handful")
  end

  test "can_convert?=false when one has units and other doesn't" do
    assert !UnitConverter.can_convert?("tbsp", nil)
    assert !UnitConverter.can_convert?(nil, "tbsp")
  end

  test "can_convert?=true when both volume or weight" do
    assert UnitConverter.can_convert?("tbsp", "tsp")
    assert UnitConverter.can_convert?("lb", "kg")
  end

  test "can_convert?=false when not both volume/weight" do
    assert !UnitConverter.can_convert?("tbsp", "kg")
    assert !UnitConverter.can_convert?("handful", "tbsp")
  end

  test "can_convert?=true when volume <-> weight volume_weight_ratio" do
    assert UnitConverter.can_convert?("tbsp", "kg", 1.5)
    assert UnitConverter.can_convert?("lb", "tsp", 1.5)
  end

  test "tbsp_to_g_ratio gives volume_weight_ratio for conversion" do
    volume_weight_ratio = UnitConverter.tbsp_to_g_ratio(2, 1)
    assert UnitConverter.convert(2, "tbsp", "g", volume_weight_ratio) == 1
  end
end