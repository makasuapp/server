# typed: strict
class IngredientAmount < T::Struct
  extend T::Sig

  prop :ingredient_id, Integer
  prop :min_needed_at, T.any(DateTime, ActiveSupport::TimeWithZone)
  prop :quantity, Float
  prop :unit, T.nilable(String)

  sig {params(ingredient_id: Integer, min_needed_at: T.any(DateTime, ActiveSupport::TimeWithZone),
    quantity: T.any(Float, Integer, BigDecimal), unit: T.nilable(String)).returns(IngredientAmount)}
  def self.mk(ingredient_id, min_needed_at, quantity, unit = nil)
    IngredientAmount.new(ingredient_id: ingredient_id, min_needed_at: min_needed_at, 
      quantity: quantity.to_f, unit: unit)
  end

  sig {params(multiplier: T.any(Float, Integer, BigDecimal)).returns(IngredientAmount)}
  def *(multiplier)
    # kinda annoying, have to make unsafe since float multiply rbi not expecting correct type
    IngredientAmount.mk(self.ingredient_id, self.min_needed_at, T.unsafe(self.quantity) * multiplier, self.unit)
  end

  sig {params(added_amount: IngredientAmount).returns(IngredientAmount)}
  def +(added_amount)
    if added_amount.ingredient_id != self.ingredient_id
      raise "Can't add different ingredients"
    elsif added_amount.min_needed_at.to_i != self.min_needed_at.to_i
      raise "Can't add ingredient with different times"
    else
      ingredient = Ingredient.find(self.ingredient_id)
      added_qty = UnitConverter.convert(added_amount.quantity, added_amount.unit, self.unit, ingredient.volume_weight_ratio)
      IngredientAmount.mk(self.ingredient_id, self.min_needed_at, self.quantity + added_qty, self.unit)
    end
  end
end