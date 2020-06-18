# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_18_182319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "day_ingredients", force: :cascade do |t|
    t.bigint "op_day_id", null: false
    t.bigint "ingredient_id", null: false
    t.float "had_qty"
    t.float "expected_qty", null: false
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "qty_updated_at"
    t.index ["ingredient_id"], name: "index_day_ingredients_on_ingredient_id"
    t.index ["op_day_id"], name: "index_day_ingredients_on_op_day_id"
  end

  create_table "detailed_instructions", force: :cascade do |t|
    t.text "instruction", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detailed_instructions_recipe_steps", id: false, force: :cascade do |t|
    t.bigint "detailed_instruction_id", null: false
    t.bigint "recipe_step_id", null: false
    t.index ["detailed_instruction_id", "recipe_step_id"], name: "detailed_instruction_recipe_step"
    t.index ["recipe_step_id", "detailed_instruction_id"], name: "recipe_step_detailed_instruction"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "op_days", force: :cascade do |t|
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_op_days_on_date"
  end

  create_table "purchased_recipes", force: :cascade do |t|
    t.date "date", null: false
    t.integer "quantity", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_purchased_recipes_on_date"
    t.index ["recipe_id"], name: "index_purchased_recipes_on_recipe_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "step_type", null: false
    t.integer "number", null: false
    t.text "instruction", null: false
    t.integer "duration_sec"
    t.integer "max_before_sec"
    t.integer "min_before_sec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_steps_on_recipe_id"
    t.index ["step_type"], name: "index_recipe_steps_on_step_type"
  end

  create_table "recipe_steps_tools", id: false, force: :cascade do |t|
    t.bigint "tool_id", null: false
    t.bigint "recipe_step_id", null: false
    t.index ["recipe_step_id", "tool_id"], name: "recipe_step_tool"
    t.index ["tool_id", "recipe_step_id"], name: "tool_recipe_step"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.float "output_qty", default: 1.0, null: false
    t.boolean "publish", default: false, null: false
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "step_inputs", force: :cascade do |t|
    t.bigint "recipe_step_id", null: false
    t.bigint "inputable_id", null: false
    t.string "inputable_type", null: false
    t.float "quantity", default: 1.0, null: false
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inputable_type", "inputable_id"], name: "index_step_inputs_on_inputable_type_and_inputable_id"
    t.index ["recipe_step_id"], name: "index_step_inputs_on_recipe_step_id"
  end

  create_table "tools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
