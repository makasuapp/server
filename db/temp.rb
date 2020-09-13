# typed: strict

kitchen = Kitchen.find_or_create_by(name: "Test")
date = DateTime.now.in_time_zone("America/Toronto")

op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)
DayIngredient.where(op_day_id: op_day.id).delete_all
DayPrep.where(op_day_id: op_day.id).delete_all
PredictedOrder.where(date: date, kitchen_id: kitchen.id).delete_all

v = Vendor.create!(name: "T&T")
day_ingredients = DayIngredient.where(op_day_id: op_day.id)
OpDayManager.create_procurement(day_ingredients, v, date, kitchen)

DayPrep.all.each do |d|
  date = d.op_day.date.to_datetime.beginning_of_day
  step = d.recipe_step
  d.min_needed_at = step.min_needed_at(date)
  d.save!
end

DayIngredient.all.each do |d|
  date = d.op_day.date.to_datetime.beginning_of_day
  d.min_needed_at = date 
  d.save!
end