# typed: strict
class IngredientAmount < T::Struct
  extend T::Sig

  prop :ingredient_id, Integer
  prop :quantity, Float
  prop :unit, T.nilable(String)

  sig {params(ingredient_id: Integer, quantity: T.any(Float, Integer, BigDecimal), 
    unit: T.nilable(String)).returns(IngredientAmount)}
  def self.mk(ingredient_id, quantity, unit = nil)
    IngredientAmount.new(ingredient_id: ingredient_id, quantity: quantity.to_f, unit: unit)
  end

  sig {params(ingredient_amounts: T::Array[IngredientAmount]).returns(T::Array[IngredientAmount])}
  def self.sum_by_id(ingredient_amounts)
    summed = ingredient_amounts.inject({}) do |sum, a|
      existing = sum[a.ingredient_id]
      if existing.nil?
        sum[a.ingredient_id] = a
      else
        sum[a.ingredient_id] = existing + a
      end

      sum
    end

    summed.values
  end

  sig {params(multiplier: T.any(Float, Integer, BigDecimal)).returns(IngredientAmount)}
  def *(multiplier)
    # kinda annoying, have to make unsafe since float multiply rbi not expecting correct type
    IngredientAmount.mk(self.ingredient_id, T.unsafe(self.quantity) * multiplier, self.unit)
  end

  sig {params(added_amount: IngredientAmount).returns(IngredientAmount)}
  def +(added_amount)
    if added_amount.ingredient_id != self.ingredient_id
      raise "Can't add different ingredients"
    else
      added_qty = UnitConverter.convert(added_amount.quantity, added_amount.unit, self.unit)
      IngredientAmount.mk(self.ingredient_id, self.quantity + added_qty, self.unit)
    end
  end
end