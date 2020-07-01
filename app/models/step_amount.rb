# typed: strict
class StepAmount < T::Struct
  extend T::Sig

  prop :recipe_step_id, Integer
  prop :quantity, Float

  sig {params(recipe_step_id: Integer, quantity: T.any(Float, Integer, BigDecimal)).returns(StepAmount)}
  def self.mk(recipe_step_id, quantity)
    StepAmount.new(recipe_step_id: recipe_step_id, quantity: quantity.to_f)
  end

  sig {params(multiplier: T.any(Float, Integer, BigDecimal)).returns(StepAmount)}
  def *(multiplier)
    # kinda annoying, have to make unsafe since float multiply rbi not expecting correct type
    StepAmount.mk(self.recipe_step_id, T.unsafe(self.quantity) * multiplier)
  end
end