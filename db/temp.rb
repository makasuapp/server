Recipe.delete_all
RecipeStep.delete_all
StepInput.delete_all
PurchasedRecipe.delete_all
DayIngredient.delete_all

d = Date.today
r = Recipe.last
PurchasedRecipe.create!(recipe_id: r.id, quantity: 4, date: d)
GenOpDayJob.new(d).perform_now