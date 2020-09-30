# typed: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

def r(name, quantity = 1, unit = nil, publish: false, output_volume_weight_ratio: nil)
  organization = Organization.find(2)
  recipe = Recipe.find_or_initialize_by(name: name, organization_id: organization.id)

  recipe.output_qty = quantity
  recipe.unit = unit
  recipe.publish = publish
  recipe.output_volume_weight_ratio = output_volume_weight_ratio
  recipe.save!

  recipe
end

def i(name, volume_weight_ratio = nil)
  organization = Organization.find(2)
  i = Ingredient.find_or_create_by!(name: name, organization_id: organization.id)

  i.volume_weight_ratio = volume_weight_ratio
  i.save!

  i
end

def t(name)
  Tool.find_or_create_by!(name: name)
end

def d(instruction)
  DetailedInstruction.find_or_create_by!(instruction: instruction)
end

def s(recipe, number, instruction, params = {})
  step = RecipeStep.find_or_initialize_by(recipe_id: recipe.id, number: number)
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

garlic = i("Garlic", 0.5829444782579292)
egg = i("Egg")
lemon_juice = i("Lemon Juice")
white_vinegar = i("White Vinegar")
canola_oil = i("Canola Oil")
sumac = i("Sumac")

salt = i("Salt", 1.154392371677825)
ground_pepper = i("Ground Pepper", 0.4057618178129438)
sugar = i("Sugar", 0.8520862920132548)
water = i("Water", 1)

cup = T.must(UnitConverter.volume_units[:cup]).short
g = T.must(UnitConverter.weight_units[:g]).short
tsp = T.must(UnitConverter.volume_units[:tsp]).short
tbsp = T.must(UnitConverter.volume_units[:tbsp]).short
oz = T.must(UnitConverter.weight_units[:oz]).short

minced_garlic = r("Minced Garlic", 10, g)
if true
  s1 = s(minced_garlic, 1, "Mince garlic")
  si(s1, "Ingredient", garlic, 10, g)
end
raise if !minced_garlic.is_valid?

egg_white = r("Egg White")
if true
  c1 = s(egg_white, 1, "Break egg and separate the white")
  si(c1, "Ingredient", egg, 1)
end
raise if !egg_white.is_valid?

garlic_sauce = r("Garlic Sauce", 820, g)
if true
  c1 = s(garlic_sauce, 1, "Add garlic, eggs, egg whites, lemon juice, and white vinegar to food processor")
  si(c1, "Recipe", minced_garlic, 100, g)
  si(c1, "Ingredient", egg, 1)
  si(c1, "Recipe", egg_white, 1)
  si(c1, "Ingredient", salt, 15, g)
  si(c1, "Ingredient", lemon_juice, 30, g)
  si(c1, "Ingredient", white_vinegar, 15, g)

  c2 = s(garlic_sauce, 2, "Turn food processor on high and slowly add canola oil")
  si(c2, "RecipeStep", c1)
  si(c2, "Ingredient", canola_oil, 600, g)

  c3 = s(garlic_sauce, 3, "With food processor on high, add water and sumac")
  si(c3, "RecipeStep", c2)
  si(c3, "Ingredient", water, 50, g)
  si(c3, "Ingredient", sumac, 10, g)
end
raise if !garlic_sauce.is_valid?

individual_garlic_sauce = r("Individual Garlic", 1, publish: true)
if true
  c1 = s(individual_garlic_sauce, 1, "Portion out garlic sauce")
  si(c1, "Recipe", garlic_sauce, 3.25, oz)
end

small_garlic_sauce = r("Garlic", 1, publish: true)
if true
  c1 = s(small_garlic_sauce, 1, "Portion out garlic sauce - 6oz for small, 12oz for large")
  si(c1, "Recipe", garlic_sauce, 6, oz)
end