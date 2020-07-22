# typed: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

def r(name, quantity = 1, unit = nil, publish = false)
  recipe = Recipe.find_or_initialize_by(name: name)

  recipe.output_qty = quantity
  recipe.unit = unit
  recipe.publish = publish
  recipe.save!

  recipe
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
  step = RecipeStep.find_or_initialize_by(recipe_id: recipe.id, number: number, step_type: type)
  step.instruction = instruction
  params.each do |k, v|
    step[k] = v
  end
  step.save!

  step.inputs.each(&:destroy)
  step.tools.delete_all
  step.detailed_instructions.delete_all

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

whole_chicken = i("Whole Chicken")
pork_belly = i("Pork Belly")
ground_pork = i("Ground Pork")

noodles = i("Chinese Noodles")

ginger = i("Ginger")
garlic = i("Garlic")
green_onion = i("Green Onion")
onion = i("Onion")
bell_pepper = i("Bell Pepper")
eggplant = i("Eggplant")
pickled_pepper = i("Pickled Red Pepper")
yacai = i("Preserved Vegetables")

soy_sauce = i("Soy Sauce")
black_vinegar = i("Black Vinegar")
cooking_wine = i("Cooking Wine")
sesame_oil = i("Sesame Oil")
red_oil_chili_paste = i("Red Oil Chili Paste")
sweet_bean_paste = i("Sweet Bean Paste")

dried_peppers = i("Dried Peppers")
sichuan_peppercorn = i("Sichuan Peppercorn")
sesame = i("White Sesame")
sesame_paste = i("Sesame Paste")
roasted_peanuts = i("Roasted Peanuts")
coriander = i("Coriander")

salt = i("Salt")
ground_pepper = i("Ground Pepper")
msg = i("MSG")
sugar = i("Sugar")
corn_starch = i("Corn Starch")
ice = i("Ice")
water = i("Water")
oil = i("Vegetable Oil")

stove = t("Stove")
wok = t("Wok")
pot = t("Stock Pot")
blender = t("Blender")
knife = t("Chef Knife")

cup = T.must(UnitConverter.volume_units[:cup]).short
g = T.must(UnitConverter.weight_units[:g]).short
tsp = T.must(UnitConverter.volume_units[:tsp]).short
tbsp = T.must(UnitConverter.volume_units[:tbsp]).short
oz = T.must(UnitConverter.weight_units[:oz]).short

pepper_paste = r("Sichuan Pepper Paste", 10, g)
if true
  s1 = s(pepper_paste, 1, "Cook dried peppers taking it on and off the heat to prevent any burning. Cook until the fragrance comes out.")
  si(s1, "Ingredient", dried_peppers, 10, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(pepper_paste, 2, "Blend until the seeds are broken into pieces. Leave out to dry")
  si(s2, "RecipeStep", s1)
  s2.tools << blender
end
raise if !pepper_paste.is_valid?

pepper_oil = r("Sichuan Pepper Oil", 130, g)
if true
  s1 = s(pepper_oil, 1, "Heat oil until 220 degrees F")
  si(s1, "Ingredient", oil, 90, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(pepper_oil, 2, "Add in sesame, cook until starting to brown, then remove the sesame")
  si(s2, "Ingredient", sesame, 10, g)
  si(s2, "RecipeStep", s1)

  s3 = s(pepper_oil, 3, "Let oil cool until 200, then pour in half of the pepper paste. Stir continuously to not burn it")
  si(s3, "RecipeStep", s2)
  si(s3, "Recipe", pepper_paste, 15, g)

  s4 = s(pepper_oil, 4, "Let oil cool until 160, then pour in the other half of the pepper paste and add the sesame back")
  si(s4, "RecipeStep", s3)
  si(s4, "Recipe", pepper_paste, 15, g)
end
raise if !pepper_oil.is_valid?

peppercorn_paste = r("Sichuan Peppercorn Paste", 10, g)
if true
  s1 = s(peppercorn_paste, 1, "Cook sichuan peppers taking it on and off the heat to prevent any burning. Cook until the peppercorns are easily crushable.")
  si(s1, "Ingredient", sichuan_peppercorn, 10, g)
  s1.tools << wok
  s1.tools << stove

  s2 = s(peppercorn_paste, 2, "Blend into a powder. Leave out to dry")
  si(s2, "RecipeStep", s1)
  s2.tools << blender
end
raise if !peppercorn_paste.is_valid?

peppercorn_oil = r("Sichuan Peppercorn Oil", 50, g)
if true
  s1 = s(peppercorn_oil, 1, "Cook on high heat to bring out the fragrance, then lower heat to bring out the flavor inside")
  si(s1, "Ingredient", oil, 40, g)
  si(s1, "Recipe", peppercorn_paste, 10, g)
  s1.tools << wok
  s1.tools << stove
end
raise if !peppercorn_oil.is_valid?

chopped_green_onion = r("Chopped Green Onions", 10, g)
if true
  s1 = s(chopped_green_onion, 1, "Chop green onions")
  si(s1, "Ingredient", green_onion, 10, g)
  s1.tools << knife
end
raise if !chopped_green_onion.is_valid?

green_onion_chunks = r("Green Onion Chunks", 10, g)
if true
  s1 = s(green_onion_chunks, 1, "Chop green onions into 1/2 inch pieces")
  si(s1, "Ingredient", green_onion, 10, g)
  s1.tools << knife
end
raise if !green_onion_chunks.is_valid?

bell_pepper_chunks = r("Bell Pepper Chunks", 10, g)
if true
  s1 = s(bell_pepper_chunks, 1, "Chop bell peppers into 1/2 inch pieces")
  si(s1, "Ingredient", bell_pepper, 10, g)
  s1.tools << knife
end
raise if !bell_pepper_chunks.is_valid?

minced_ginger = r("Minced Ginger", 10, g)
if true
  s1 = s(minced_ginger, 1, "Mince ginger")
  si(s1, "Ingredient", ginger, 10, g)
  s1.tools << knife
end
raise if !minced_ginger.is_valid?

minced_garlic = r("Minced Garlic", 10, g)
if true
  s1 = s(minced_garlic, 1, "Mince garlic")
  si(s1, "Ingredient", garlic, 10, g)
  s1.tools << knife
end
raise if !minced_garlic.is_valid?

sliced_onion = r("Sliced Onion", 10, g)
if true
  s1 = s(sliced_onion, 1, "Slice onion thinly")
  si(s1, "Ingredient", onion, 10, g)
  s1.tools << knife
end
raise if !sliced_onion.is_valid?

sliced_ginger = r("Sliced Ginger", 10, g)
if true
  s1 = s(sliced_ginger, 1, "Slice ginger thinly")
  si(s1, "Ingredient", ginger, 10, g)
  s1.tools << knife
end
raise if !sliced_ginger.is_valid?

sliced_garlic = r("Sliced Garlic", 10, g)
if true
  s1 = s(sliced_garlic, 1, "Slice garlic thinly")
  si(s1, "Ingredient", garlic, 10, g)
  s1.tools << knife
end
raise if !sliced_garlic.is_valid?

sauce = r("Mouth Watering Chicken Sauce")
if true
  s1 = s(sauce, 1, "Mix salt, MSG, sugar 1:1:3")
  si(s1, "Ingredient", salt, 1, tsp)
  si(s1, "Ingredient", msg, 1, tsp)
  si(s1, "Ingredient", sugar, 3, tsp)

  s2 = s(sauce, 2, "Drizzle in soy sauce and vinegar")
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", soy_sauce, 1, tbsp)
  si(s2, "Ingredient", black_vinegar, 1, tsp)

  s3 = s(sauce, 3, "Mix sesame paste and sesame oil 1:2 til emulsified")
  si(s3, "Ingredient", sesame_paste, 1, tbsp)
  si(s3, "Ingredient", sesame_oil, 2, tbsp)

  s4 = s(sauce, 4, "Mix all together and add some peppercorn paste, pepper paste, pepper oil, and peppercorn oil")
  si(s4, "RecipeStep", s2)
  si(s4, "RecipeStep", s3)
  si(s4, "Recipe", pepper_paste, 1, tsp)
  si(s4, "Recipe", pepper_oil, 2, tbsp)
  si(s4, "Recipe", peppercorn_paste, 1, tsp)
  si(s4, "Recipe", peppercorn_oil, 1, tbsp)

  s5 = s(sauce, 5, "Add in minced ginger and garlic")
  si(s5, "RecipeStep", s4)
  si(s5, "Recipe", minced_garlic, 1, tbsp)
  si(s5, "Recipe", minced_ginger, 1, tsp)
end
raise if !sauce.is_valid?

chicken = r("Mouth Watering Chicken", 2, nil, true)
if true
  s1 = s(chicken, 1, "Dry brine chicken overnight", "prep",
    {min_before_sec: 60 * 60 * 8}
  )
  s1.detailed_instructions << d("Rub salt all over chicken over and under the skin. Store uncovered in a fridge")
  si(s1, "Ingredient", whole_chicken)
  si(s1, "Ingredient", salt, 5, tbsp)

  s2 = s(chicken, 2, 
    "Submerge whole chicken in water with dried peppers, sichuan peppercorn, green onion chunks, ginger chunks, lots of salt. Squeeze the green onions and ginger to get juices into it."
  )
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", water, 8, cup)
  si(s2, "Ingredient", dried_peppers, 3)
  si(s2, "Ingredient", sichuan_peppercorn, 10)
  si(s2, "Ingredient", ginger, 2, g)
  si(s2, "Ingredient", green_onion, 1)
  si(s2, "Ingredient", salt, 3, tbsp)
  s2.tools << pot

  s3 = s(chicken, 3, "Cook on low heat for 20 minutes", "prep", 
    {duration_sec: 60 * 20}
  )
  si(s3, "RecipeStep", s2)
  s3.tools << stove

  s4 = s(chicken, 4, "Dunk in ice bath to stop cooking")
  si(s4, "RecipeStep", s3)
  #TODO: how do we handle reusable ingredients that don't scale with recipes?
  si(s4, "Ingredient", ice)

  c1 = s(chicken, 1, "Cut chicken into cubes", "cook")
  si(c1, "RecipeStep", s4)
  c1.tools << knife

  c2 = s(chicken, 2, "Drizzle on sauce, green onions as garnish", "cook")
  si(c2, "RecipeStep", c1)
  si(c2, "Recipe", sauce)
  si(c2, "Recipe", chopped_green_onion, 10, g)
end
raise if !chicken.is_valid?

two_pork = r("Twice Cooked Pork", 1, nil, true)
if true
  s1 = s(two_pork, 1, "Boil pork belly for an hour. Let it cool, then freeze it", "prep",
    {min_before_sec: 60 * 60 * 3, duration_sec: 60 * 80}
  )
  si(s1, "Ingredient", pork_belly, 250, g)
  s1.tools << pot
  s1.tools << stove

  s2 = s(two_pork, 2, "Cut pork belly as thin as possible into slices")
  si(s2, "RecipeStep", s1)
  s2.tools << knife

  c1 = s(two_pork, 1, "High heat lots of oil, fry the pork belly until starting to caramelize", "cook",
    {duration_sec: 60}
  )
  si(c1, "RecipeStep", s2)
  si(c1, "Ingredient", oil, 2, tbsp)
  c1.tools << wok
  c1.tools << stove

  c2 = s(two_pork, 2, "Add in other ingredients, stir fry a little til cooked but still crunchy, take off heat", "cook",
    {duration_sec: 90}
  )
  si(c2, "RecipeStep", c1)
  si(c2, "Recipe", sliced_onion, 300, g)
  si(c2, "Recipe", bell_pepper_chunks, 200, g)
  si(c2, "Recipe", green_onion_chunks, 20, g)

  c3 = s(two_pork, 3, "Small heat, small oil, stir fry garlic, ginger, red oil chili paste, sweet bean paste", "cook")
  si(c3, "Ingredient", oil, 1, tsp)
  si(c3, "Recipe", sliced_garlic, 10, g)
  si(c3, "Recipe", sliced_ginger, 10, g)
  si(c3, "Ingredient", red_oil_chili_paste, 1, tbsp)
  si(c3, "Ingredient", sweet_bean_paste, 0.5, tbsp)

  c4 = s(two_pork, 4, "Combine everything, add seasoning", "cook")
  si(c4, "RecipeStep", c2)
  si(c4, "RecipeStep", c3)
  si(c4, "Ingredient", sugar, 0.25, tsp)
  si(c4, "Ingredient", ground_pepper, 0.5, tsp)
  si(c4, "Ingredient", msg, 0.5, tsp)
  si(c4, "Ingredient", soy_sauce, 1, tsp)
  si(c4, "Ingredient", cooking_wine, 1, tbsp)

  c5 = s(two_pork, 5, "Finish with some pepper oil", "cook")
  si(c5, "RecipeStep", c4)
  si(c5, "Recipe", pepper_oil, 1, tbsp)
end
raise if !two_pork.is_valid?

dd_sauce = r("Dan Dan Sauce", 4)
if true
  s1 = s(dd_sauce, 1, "Mix ingredients")
  si(s1, "Ingredient", salt, 1, tsp)
  si(s1, "Ingredient", msg, 1, tsp)
  si(s1, "Ingredient", soy_sauce, 1, tbsp)
  si(s1, "Ingredient", black_vinegar, 3, tbsp)
  si(s1, "Ingredient", sugar, 1, tbsp)
  si(s1, "Recipe", pepper_oil, 2, tbsp)
  si(s1, "Recipe", peppercorn_oil, 1, tbsp)
  si(s1, "Ingredient", sesame_paste, 2, tbsp)
  si(s1, "Ingredient", sesame_oil, 4, tbsp)
end
raise if !dd_sauce.is_valid?

dan_dan = r("Dan Dan Noodles", 1, nil, true)
if true
  s1 = s(dan_dan, 1, "High heat cook the pork with some cooking wine and salt")
  si(s1, "Ingredient", ground_pork, 30, g)
  si(s1, "Ingredient", oil, 2, tsp)
  si(s1, "Ingredient", cooking_wine, 1, tsp)
  si(s1, "Ingredient", salt, 1, tsp)
  s1.tools << wok
  s1.tools << stove

  s2 = s(dan_dan, 2, "Add in peppercorn, ya cai, garlic. Once fragrant take off the heat")
  si(s2, "RecipeStep", s1)
  si(s2, "Recipe", peppercorn_paste, 1, tsp)
  si(s2, "Recipe", minced_garlic, 0.25, tsp)
  si(s2, "Ingredient", yacai, 15, g)

  c1 = s(dan_dan, 1, "Boil noodles. After cooked, run through cold water", "cook",
    {max_before_sec: 60 * 20}
  )
  si(c1, "Ingredient", noodles, 1.5, oz)
  c1.tools << pot
  c1.tools << stove

  c2 = s(dan_dan, 2, "Combine sauce, roasted peanuts, green onions, pork", "cook")
  si(c2, "Recipe", dd_sauce, 1)
  si(c2, "Recipe", chopped_green_onion, 4, g)
  si(c2, "Ingredient", roasted_peanuts, 0.5, tbsp)
  si(c2, "RecipeStep", s2)

  c3 = s(dan_dan, 3, "Combine and serve", "cook")
  si(c3, "RecipeStep", c1)
  si(c3, "RecipeStep", c2)
end
raise if !dan_dan.is_valid?

yx_sauce = r("Yuxiang Sauce")
if true
  s1 = s(yx_sauce, 1, "Mix ingredients")
  si(s1, "Ingredient", salt, 1, g)
  si(s1, "Ingredient", black_vinegar, 35, g)
  si(s1, "Ingredient", sugar, 40, g)
  si(s1, "Ingredient", ground_pepper, 0.5, g)
  si(s1, "Ingredient", soy_sauce, 5, g)

  s2 = s(yx_sauce, 2, "Mix corn starch with cold water")
  si(s2, "Ingredient", corn_starch, 2, g)
  si(s2, "Ingredient", water, 13, g)

  s3 = s(yx_sauce, 3, "Add corn starch slurry to other ingredients")
  si(s3, "RecipeStep", s1)
  si(s3, "RecipeStep", s2)
end
raise if !yx_sauce.is_valid?

yuxiang = r("Yuxiang Eggplant", 1, nil, true)
if true
  s1 = s(yuxiang, 1, "Cut eggplant into long strips, soak in salty water for 15 minutes, dry it off after")
  si(s1, "Ingredient", eggplant, 2)
  si(s1, "Ingredient", salt, 2, tbsp)
  si(s1, "Ingredient", water, 4, cup)
  s1.tools << knife

  s2 = s(yuxiang, 2, "Sprinkle eggplant with corn starch. Heat up oil to medium and semi-fry eggplant until crispy")
  s1.detailed_instructions << d("Do it in batches, don't overcrowd it. Put in 1-2 tbsp of oil per batch to cover bottom and fry until eggplant changes color.")
  si(s2, "RecipeStep", s1)
  si(s2, "Ingredient", corn_starch, 2, tbsp)
  si(s2, "Ingredient", oil, 0.25, cup)
  s2.tools << wok
  s2.tools << stove

  c1 = s(yuxiang, 1, "High heat cook the pork with cooking wine and salt", "cook")
  si(c1, "Ingredient", ground_pork, 100, g)
  si(c1, "Ingredient", cooking_wine, 1, tsp)
  si(c1, "Ingredient", salt, 1, tsp)
  si(c1, "Ingredient", oil, 2, tbsp)
  c1.tools << wok
  c1.tools << stove

  c2 = s(yuxiang, 2, "Add in garlic, green onion, ginger, pickled peppers, sauce", "cook")
  si(c2, "RecipeStep", c1)
  si(c2, "Recipe", minced_ginger, 1, tbsp)
  si(c2, "Recipe", minced_garlic, 1, tbsp)
  si(c2, "Recipe", chopped_green_onion, 20, g)
  si(c2, "Ingredient", pickled_pepper, 3)
  si(c2, "Recipe", yx_sauce)

  c3 = s(yuxiang, 3, "Add back in the eggplant and garnish with coriander", "cook")
  si(c3, "RecipeStep", c2)
  si(c3, "RecipeStep", s2)
  si(c2, "Ingredient", coriander, 10, g)
end
raise if !yuxiang.is_valid?