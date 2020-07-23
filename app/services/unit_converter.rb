# typed: strict

class WeightUnit < T::Struct
  extend T::Sig

  prop :short, String
  prop :long, String
  prop :to_g, Float

  sig {params(short: String, long: String, to_g: T.any(Float, Integer)).returns(WeightUnit)}
  def self.mk(short, long, to_g)
    WeightUnit.new(short: short, long: long, to_g: to_g.to_f)
  end
end

class VolumeUnit < T::Struct
  extend T::Sig

  prop :short, String
  prop :long, String
  prop :to_ml, Float

  sig {params(short: String, long: String, to_ml: T.any(Float, Integer)).returns(VolumeUnit)}
  def self.mk(short, long, to_ml)
    VolumeUnit.new(short: short, long: long, to_ml: to_ml.to_f)
  end
end

class UnitConverter
  extend T::Sig

  sig {returns(T::Hash[Symbol, WeightUnit])}
  def self.weight_units
    {
      oz: WeightUnit.mk("oz", "ounce", 28.35),
      g: WeightUnit.mk("g", "gram", 1),
      kg: WeightUnit.mk("kg", "kilograms", 1000),
      lb: WeightUnit.mk("lb", "pound", 453.6)
    }
  end

  sig {returns(T::Hash[Symbol, VolumeUnit])}
  def self.volume_units
    {
      tsp: VolumeUnit.mk("tsp", "teaspoon", 4.929),
      tbsp: VolumeUnit.mk("tbsp", "tablespoon", 14.787),
      cup: VolumeUnit.mk("cup", "cup", 237),
      mL: VolumeUnit.mk("mL", "millilitre", 1),
      L: VolumeUnit.mk("L", "litre", 1000),
      gal: VolumeUnit.mk("gal", "gallon", 3785),
      qt: VolumeUnit.mk("qt", "quart", 946)
    }
  end

  sig{params(unit: T.nilable(String)).returns(T.nilable(VolumeUnit))}
  def self.get_volume(unit)
    self.volume_units[unit.try(:to_sym)]
  end

  sig{params(unit: T.nilable(String)).returns(T.nilable(WeightUnit))}
  def self.get_weight(unit)
    self.weight_units[unit.try(:to_sym)]
  end

  sig{params(input_qty: T.any(Float, Integer, BigDecimal), input_unit: T.nilable(String), 
    output_unit: T.nilable(String), volume_weight_ratio: T.nilable(Float)).returns(Float)}
  def self.convert(input_qty, input_unit = nil, output_unit = nil, volume_weight_ratio = nil)
    err = "Can't convert between these units. input=#{input_unit}, output=#{output_unit}, volume_weight_ratio=#{volume_weight_ratio}"
    if input_unit == output_unit
      input_qty.to_f
    elsif !UnitConverter.can_convert?(input_unit, output_unit, volume_weight_ratio)
      raise err
    else
      input_v = self.get_volume(input_unit)
      input_w = self.get_weight(input_unit)
      output_v = self.get_volume(output_unit)
      output_w = self.get_weight(output_unit)

      if (input_v.present? && output_v.present?)
        input_qty.to_f * (input_v.to_ml / output_v.to_ml)
      elsif (input_w.present? && output_w.present?)
        input_qty.to_f * (input_w.to_g / output_w.to_g)
      else
        #volume <-> conversion
        if volume_weight_ratio.present?
          if input_v.present? && output_w.present?
            input_qty.to_f * (input_v.to_ml / output_w.to_g) * volume_weight_ratio
          elsif input_w.present? && output_v.present?
            input_qty.to_f * (input_w.to_g / output_v.to_ml) / volume_weight_ratio
          else
            raise err
          end
        else
          raise err
        end
      end
    end
  end

  sig{params(unit_1: T.nilable(String), unit_2: T.nilable(String), 
    volume_weight_ratio: T.nilable(Float)).returns(T::Boolean)}
  def self.can_convert?(unit_1, unit_2, volume_weight_ratio = nil)
    one_is_v = self.get_volume(unit_1).present?
    one_is_w = self.get_weight(unit_1).present?
    two_is_v = self.get_volume(unit_2).present?
    two_is_w = self.get_weight(unit_2).present?

    (unit_1 == unit_2) || (one_is_v && two_is_v) || (one_is_w && two_is_w) ||
      (((one_is_v && two_is_w) || (one_is_w && two_is_v)) && volume_weight_ratio.present?)
  end

  sig {params(tbsp_amount: T.any(Float, Integer), g_amount: T.any(Float, Integer)).returns(Float)}
  def self.tbsp_to_g_ratio(tbsp_amount, g_amount)
      g_amount.to_f  / tbsp_amount.to_f / self.volume_units[:tbsp].to_ml
  end
end