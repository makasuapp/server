# typed: strict

class UnitConverter
  extend T::Sig

  sig{params(input_qty: T.any(Float, Integer, BigDecimal), input_unit: T.nilable(String), 
    output_unit: T.nilable(String)).returns(Float)}
  def self.convert(input_qty, input_unit = nil, output_unit = nil)
    if input_unit == output_unit
      input_qty.to_f
    elsif !UnitConverter.unit_matches?(input_unit, output_unit)
      raise "Can't convert between these units. input=#{input_unit}, output=#{output_unit}"
    else
      #TODO(unit_conversion)
      input_qty.to_f
    end
  end

  sig{params(unit_1: T.nilable(String), unit_2: T.nilable(String)).returns(T::Boolean)}
  #for now, unit matches if both are nil or not nil
  #should actually check conversion is possible between the two units
  def self.unit_matches?(unit_1, unit_2)
    unit_1.nil? ^ unit_2.present? 
  end
end