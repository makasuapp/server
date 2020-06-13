# typed: strict

class UnitConverter
  extend T::Sig

  sig{params(input_qty: T.any(Float, Integer, BigDecimal), input_unit: T.nilable(String), 
    output_unit: T.nilable(String)).returns(Float)}
  def self.convert(input_qty, input_unit = nil, output_unit = nil)
    if input_unit == output_unit
      input_qty.to_f
    elsif input_unit == nil || output_unit == nil
      raise "Can't convert to/from unit and unit-less"
    else
      #TODO(unit_conversion)
      input_qty.to_f
    end
  end
end