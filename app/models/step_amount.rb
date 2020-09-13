# typed: strict
class StepAmount < T::Struct
  extend T::Sig

  prop :recipe_step_id, Integer
  prop :min_needed_at, T.any(DateTime, ActiveSupport::TimeWithZone)
  prop :quantity, Float

  sig {params(recipe_step_id: Integer, min_needed_at: T.any(DateTime, ActiveSupport::TimeWithZone), 
    quantity: T.any(Float, Integer, BigDecimal)).returns(StepAmount)}
  def self.mk(recipe_step_id, min_needed_at, quantity)
    StepAmount.new(recipe_step_id: recipe_step_id, min_needed_at: min_needed_at, quantity: quantity.to_f)
  end

  sig {params(multiplier: T.any(Float, Integer, BigDecimal)).returns(StepAmount)}
  def *(multiplier)
    # kinda annoying, have to make unsafe since float multiply rbi not expecting correct type
    StepAmount.mk(self.recipe_step_id, self.min_needed_at, T.unsafe(self.quantity) * multiplier)
  end
end