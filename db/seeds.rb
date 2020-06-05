# typed: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

def r(name)
  Recipe.find_or_create_by!(name: name)
end

def i(name)
  Ingredient.find_or_create_by!(name: name)
end

def s(recipe, number, instruction, type = "prep", params = {})
  step = RecipeStep.new(params)
  step.recipe_id = recipe.id
  step.number = number
  step.step_type = type
  step.instruction = instruction
  step.save!

  step
end

def si(step, inputable_type, inputable, quantity = 1, unit = nil)
  input = StepInput.new
  input.recipe_step_id = step.id
  input.inputable_type = inputable_type
  input.inputable_id = inputable.id
  input.quantity = quantity
  input.unit = unit
  input.save!
end

salt = i("Salt")
msg = i("MSG")
sugar = i("Sugar")
soy_sauce = i("Soy Sauce")
sesame_paste = i("Sesame Paste")
sesame_oil = i("Sesame Oil")
sichuan_peppercorn = i("Sichuan Peppercorn")
black_vinegar = i("Black Vinegar")
ginger = i("Ginger")
garlic = i("Garlic")
green_onion = i("Green Onion")
whole_chicken = i("Whole Chicken")
ice = i("Ice")
water = i("Water")

pepper_paste = r("Sichuan Pepper Paste")
pepper_oil = r("Sichuan Pepper Oil")
peppercorn_paste = r("Sichuan Peppercorn Paste")
peppercorn_oil = r("Sichuan Peppercorn Oil")

#TODO: recipe needs output serving size? or how scale?
chopped_green_onion = r("Chopped Green Onions")
minced_ginger = r("Minced Ginger")
minced_garlic = r("Minced Garlic")

sauce = r("Mouth Watering Chicken Sauce")
#TODO(recipe_test): adjust units
if sauce.recipe_steps.empty?
  s1 = s(sauce, 1, "Mix salt, MSG, sugar 1:1:3")
  si(s1, "Ingredient", salt, 1, "tsp")
  si(s1, "Ingredient", msg, 1, "tsp")
  si(s1, "Ingredient", sugar, 3, "tsp")

  s2 = s(sauce, 2, "Drizzle in soy sauce and vinegar")
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", soy_sauce, 2, "tbsp")
  si(s2, "Ingredient", black_vinegar, 1, "tbsp")

  s3 = s(sauce, 3, "Mix sesame paste and sesame oil 1:2 til emulsified")
  si(s3, "Ingredient", sesame_paste, 3, "tbsp")
  si(s3, "Ingredient", sesame_oil, 6, "tbsp")

  s4 = s(sauce, 4, "Mix all together and add some peppercorn paste, pepper paste, pepper oil, and peppercorn oil")
  si(s4, "RecipeStep", s2)
  si(s4, "RecipeStep", s3)
  si(s4, "Recipe", pepper_paste, 1, "tsp")
  si(s4, "Recipe", pepper_oil, 3, "tbsp")
  si(s4, "Recipe", peppercorn_paste, 1, "tsp")
  si(s4, "Recipe", peppercorn_oil, 1, "tbsp")

  s5 = s(sauce, 5, "Add in minced ginger and garlic")
  si(s5, "RecipeStep", s4)
  si(s5, "Recipe", minced_garlic)
  si(s5, "Recipe", minced_ginger)
end

chicken = r("Mouth Watering Chicken")
