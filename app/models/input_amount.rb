# typed: strict
class InputAmount < T::Struct
  extend T::Sig

  prop :inputable_id, Integer
  prop :inputable_type, String
  prop :min_needed_at, T.any(DateTime, ActiveSupport::TimeWithZone)
  prop :quantity, Float
  prop :unit, T.nilable(String)

  sig {params(inputable_id: Integer, inputable_type: String, min_needed_at: T.any(DateTime, ActiveSupport::TimeWithZone),
    quantity: T.any(Float, Integer, BigDecimal), unit: T.nilable(String)).returns(InputAmount)}
  def self.mk(inputable_id, inputable_type, min_needed_at, quantity, unit = nil)
    InputAmount.new(inputable_id: inputable_id, inputable_type: inputable_type, 
      min_needed_at: min_needed_at, quantity: quantity.to_f, unit: unit)
  end

  sig {params(multiplier: T.any(Float, Integer, BigDecimal)).returns(InputAmount)}
  def *(multiplier)
    # kinda annoying, have to make unsafe since float multiply rbi not expecting correct type
    InputAmount.mk(self.inputable_id, self.inputable_type, self.min_needed_at, 
      T.unsafe(self.quantity) * multiplier, self.unit)
  end

  sig {params(added_amount: InputAmount).returns(InputAmount)}
  def +(added_amount)
    if added_amount.inputable_id != self.inputable_id || added_amount.inputable_type != self.inputable_type
      raise "Can't add different inputs"
    elsif added_amount.min_needed_at.to_i != self.min_needed_at.to_i
      raise "Can't add inputs with different times"
    else
      input = self.inputable
      added_qty = UnitConverter.convert(added_amount.quantity, added_amount.unit, self.unit, input.volume_weight_ratio)
      InputAmount.mk(self.inputable_id, self.inputable_type, self.min_needed_at, 
        self.quantity + added_qty, self.unit)
    end
  end

  sig {returns(T.any(Ingredient, Recipe))}
  def inputable
    #why isn't DayInputType::Ingredient working here
    if self.inputable_type == "Ingredient"
      Ingredient.find(self.inputable_id)
    elsif self.inputable_type == "Recipe"
      input = Recipe.find(self.inputable_id)
    else
      raise "Unexpected inputable type #{self.inputable_type}"
    end
  end
end