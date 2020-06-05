# typed: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

def r(name, quantity = 1, unit = nil)
  Recipe.find_or_create_by!(name: name, output_quantity: quantity, unit: unit)
end

def i(name)
  Ingredient.find_or_create_by!(name: name)
end

def t(name)
  Tool.find_or_create_by!(name: name)
end

def d(instruction)
  DetailedInstruction.find_or_create_by!(instruction: instruction)
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
sesame = i("White Sesame")
sesame_paste = i("Sesame Paste")
sesame_oil = i("Sesame Oil")
sichuan_peppercorn = i("Sichuan Peppercorn")
dried_peppers = i("Dried Peppers")
black_vinegar = i("Black Vinegar")
ginger = i("Ginger")
garlic = i("Garlic")
green_onion = i("Green Onion")
whole_chicken = i("Whole Chicken")
ice = i("Ice")
water = i("Water")
oil = i("Vegetable Oil")

stove = t("Stove")
wok = t("Wok")
pot = t("Stock Pot")
blender = t("Blender")
knife = t("Chef Knife")

g = "grams"
tsp = "teaspoons"
tbsp = "tablespoons"

pepper_paste = r("Sichuan Pepper Paste", 10, g)
if pepper_paste.recipe_steps.empty?
  s1 = s(pepper_paste, 1, "Cook dried peppers taking it on and off the heat to prevent any burning. Cook until the fragrance comes out.")
  si(s1, "Ingredient", dried_peppers, 10, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(pepper_paste, 2, "Blend until the seeds are broken into pieces. Leave out to dry")
  si(s2, "RecipeStep", s1)
  s2.tools << blender
end

pepper_oil = r("Sichuan Pepper Oil", 130, g)
if pepper_oil.recipe_steps.empty?
  s1 = s(pepper_oil, 1, "Heat oil until 220 degrees F")
  si(s1, "Ingredient", oil, 90, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(pepper_oil, 2, "Add in sesame, cook until starting to brown, then remove the sesame")
  si(s2, "Ingredient", sesame, 10, g)
  si(s2, "RecipeStep", s1)

  s3 = s(pepper_oil, 3, "Let oil cool until 200, then pour in half of the pepper paste. Stir continuously to not burn it")
  si(s3, "RecipeStep", s2)
  si(s3, "Recipe", pepper_paste, 1.5)

  s4 = s(pepper_oil, 4, "Let oil cool until 160, then pour in the other half of the pepper paste and add the sesame back")
  si(s4, "RecipeStep", s3)
  si(s4, "Recipe", pepper_paste, 1.5)
end

peppercorn_paste = r("Sichuan Peppercorn Paste", 10, g)
if peppercorn_paste.recipe_steps.empty?
  s1 = s(peppercorn_paste, 1, "Cook sichuan peppers taking it on and off the heat to prevent any burning. Cook until the peppercorns are easily crushable.")
  si(s1, "Ingredient", sichuan_peppercorn, 10, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(peppercorn_paste, 2, "Blend into a powder. Leave out to dry")
  si(s2, "RecipeStep", s1)
  s2.tools << blender
end

peppercorn_oil = r("Sichuan Peppercorn Oil", 50, g)
if peppercorn_oil.recipe_steps.empty?
  s1 = s(peppercorn_oil, 1, "Cook on high heat to bring out the fragrance, then lower heat to bring out the flavor inside")
  si(s1, "Ingredient", oil, 40, g)
  si(s1, "Recipe", peppercorn_paste, 1)
  s1.tools << wok
  s1.tools << stove
end

chopped_green_onion = r("Chopped Green Onions", 100, g)
if chopped_green_onion.recipe_steps.empty?
  s1 = s(chopped_green_onion, 1, "Chop green onions")
  si(s1, "Ingredient", green_onion, 100, g)
  s1.tools << knife
end

minced_ginger = r("Minced Ginger", 100, g)
if minced_ginger.recipe_steps.empty?
  s1 = s(minced_ginger, 1, "Mince ginger")
  si(s1, "Ingredient", ginger, 100, g)
  s1.tools << knife
end

minced_garlic = r("Minced Garlic", 100, g)
if minced_garlic.recipe_steps.empty?
  s1 = s(minced_garlic, 1, "Mince garlic")
  si(s1, "Ingredient", garlic, 100, g)
  s1.tools << knife
end

sauce = r("Mouth Watering Chicken Sauce")
#TODO(recipe_test): adjust units
if sauce.recipe_steps.empty?
  s1 = s(sauce, 1, "Mix salt, MSG, sugar 1:1:3")
  si(s1, "Ingredient", salt, 1, tsp)
  si(s1, "Ingredient", msg, 1, tsp)
  si(s1, "Ingredient", sugar, 3, tsp)

  s2 = s(sauce, 2, "Drizzle in soy sauce and vinegar")
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", soy_sauce, 2, tbsp)
  si(s2, "Ingredient", black_vinegar, 1, tbsp)

  s3 = s(sauce, 3, "Mix sesame paste and sesame oil 1:2 til emulsified")
  si(s3, "Ingredient", sesame_paste, 3, tbsp)
  si(s3, "Ingredient", sesame_oil, 6, tbsp)

  s4 = s(sauce, 4, "Mix all together and add some peppercorn paste, pepper paste, pepper oil, and peppercorn oil")
  si(s4, "RecipeStep", s2)
  si(s4, "RecipeStep", s3)
  si(s4, "Recipe", pepper_paste, 1, tsp)
  si(s4, "Recipe", pepper_oil, 3, tbsp)
  si(s4, "Recipe", peppercorn_paste, 1, tsp)
  si(s4, "Recipe", peppercorn_oil, 1, tbsp)

  s5 = s(sauce, 5, "Add in minced ginger and garlic")
  si(s5, "RecipeStep", s4)
  si(s5, "Recipe", minced_garlic)
  si(s5, "Recipe", minced_ginger)
end

chicken = r("Mouth Watering Chicken", 2)
if chicken.recipe_steps.empty?
  s1 = s(chicken, 1, "Dry brine chicken overnight", "prep",
    {min_before_sec: 60 * 60 * 8}
  )
  s1.detailed_instructions << d("Rub salt all over chicken over and under the skin. Store uncovered in a fridge")
  si(s1, "Ingredient", whole_chicken)
  si(s1, "Ingredient", salt)

  s2 = s(chicken, 2, 
    "Submerge whole chicken in water with dried peppers, sichuan peppercorn, green onion chunks, ginger chunks, lots of salt. Squeeze the green onions and ginger to get juices into it."
  )
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", water)
  si(s2, "Ingredient", dried_peppers, 3)
  si(s2, "Ingredient", sichuan_peppercorn, 10)
  si(s2, "Ingredient", ginger, 4, "cm")
  si(s2, "Ingredient", green_onion, 1)
  si(s2, "Ingredient", salt, 5, "tbsp")
  s2.tools << pot

  s3 = s(chicken, 3, "Cook on low heat for 20 minutes", "prep", 
    {duration_sec: 60 * 20}
  )
  si(s3, "RecipeStep", s2)
  s3.tools << stove

  s4 = s(chicken, 4, "Dunk in ice bath to stop cooking")
  si(s4, "RecipeStep", s3)
  si(s4, "Ingredient", ice)
  si(s4, "Ingredient", water)

  c1 = s(chicken, 1, "Cut chicken into cubes", "cook")
  si(c1, "RecipeStep", s4)
  c1.tools << knife

  c2 = s(chicken, 2, "Drizzle on sauce and green onions as garnish", "cook")
  si(c2, "RecipeStep", c1)
  si(c2, "Recipe", sauce)
  si(c2, "Recipe", chopped_green_onion)
end
