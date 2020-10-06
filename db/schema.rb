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

ActiveRecord::Schema.define(version: 2020_10_06_163931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email"
    t.index ["phone_number"], name: "index_customers_on_phone_number"
  end

  create_table "day_inputs", force: :cascade do |t|
    t.bigint "op_day_id", null: false
    t.bigint "inputable_id", null: false
    t.float "had_qty"
    t.float "expected_qty", null: false
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "qty_updated_at"
    t.datetime "min_needed_at", null: false
    t.bigint "kitchen_id", null: false
    t.string "inputable_type", default: "Ingredient", null: false
    t.index ["inputable_type", "inputable_id"], name: "index_day_inputs_on_inputable_type_and_inputable_id"
    t.index ["kitchen_id", "min_needed_at"], name: "index_day_inputs_on_kitchen_id_and_min_needed_at"
    t.index ["op_day_id"], name: "index_day_inputs_on_op_day_id"
  end

  create_table "day_preps", force: :cascade do |t|
    t.bigint "op_day_id", null: false
    t.bigint "recipe_step_id", null: false
    t.float "expected_qty", null: false
    t.float "made_qty"
    t.datetime "qty_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "min_needed_at", null: false
    t.bigint "kitchen_id", null: false
    t.index ["kitchen_id", "min_needed_at"], name: "index_day_preps_on_kitchen_id_and_min_needed_at"
    t.index ["op_day_id"], name: "index_day_preps_on_op_day_id"
    t.index ["recipe_step_id"], name: "index_day_preps_on_recipe_step_id"
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
    t.float "volume_weight_ratio"
    t.bigint "organization_id", null: false
    t.bigint "default_vendor_id"
    t.index ["organization_id"], name: "index_ingredients_on_organization_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.bigint "kitchen_id", null: false
    t.string "integration_type", null: false
    t.string "wix_app_instance_id"
    t.string "wix_restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integration_type", "wix_restaurant_id"], name: "index_integrations_on_integration_type_and_wix_restaurant_id"
    t.index ["kitchen_id"], name: "index_integrations_on_kitchen_id"
  end

  create_table "item_prices", force: :cascade do |t|
    t.bigint "recipe_id"
    t.integer "price_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_item_prices_on_recipe_id"
  end

  create_table "kitchens", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
  end

  create_table "op_days", force: :cascade do |t|
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kitchen_id", null: false
    t.index ["date", "kitchen_id"], name: "index_op_days_on_date_and_kitchen_id"
    t.index ["date"], name: "index_op_days_on_date"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "recipe_id", null: false
    t.integer "quantity", null: false
    t.datetime "started_at"
    t.datetime "done_at"
    t.integer "price_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["recipe_id"], name: "index_order_items_on_recipe_id"
  end

  create_table "order_versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_order_versions_on_item_type_and_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "aasm_state", null: false
    t.string "order_type", null: false
    t.datetime "for_time"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kitchen_id", null: false
    t.bigint "integration_id"
    t.string "integration_order_id"
    t.string "comment"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["integration_id", "integration_order_id"], name: "index_orders_on_integration_id_and_integration_order_id"
    t.index ["kitchen_id", "for_time", "created_at", "aasm_state"], name: "idx_kitchen_time"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predicted_orders", force: :cascade do |t|
    t.datetime "date", null: false
    t.integer "quantity", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kitchen_id", null: false
    t.index ["date", "kitchen_id"], name: "index_predicted_orders_on_date_and_kitchen_id"
    t.index ["date"], name: "index_predicted_orders_on_date"
    t.index ["recipe_id"], name: "index_predicted_orders_on_recipe_id"
  end

  create_table "procurement_items", force: :cascade do |t|
    t.bigint "procurement_order_id", null: false
    t.bigint "ingredient_id", null: false
    t.float "quantity", null: false
    t.string "unit"
    t.string "price_unit"
    t.integer "price_cents"
    t.float "got_qty"
    t.string "got_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_procurement_items_on_ingredient_id"
    t.index ["procurement_order_id"], name: "index_procurement_items_on_procurement_order_id"
  end

  create_table "procurement_orders", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.datetime "for_date", null: false
    t.string "order_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "kitchen_id", null: false
    t.index ["kitchen_id", "for_date"], name: "index_procurement_orders_on_kitchen_id_and_for_date"
    t.index ["vendor_id"], name: "index_procurement_orders_on_vendor_id"
  end

  create_table "recipe_snapshots", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "unit"
    t.float "output_qty", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_snapshots_on_recipe_id"
  end

  create_table "recipe_snapshots_step_inputs", id: false, force: :cascade do |t|
    t.bigint "recipe_snapshot_id", null: false
    t.bigint "step_input_id", null: false
    t.index ["recipe_snapshot_id", "step_input_id"], name: "recipe_snapshot_input"
    t.index ["step_input_id", "recipe_snapshot_id"], name: "step_input_snapshot"
  end

  create_table "recipe_snapshots_steps", id: false, force: :cascade do |t|
    t.bigint "recipe_snapshot_id", null: false
    t.bigint "recipe_step_id", null: false
    t.index ["recipe_snapshot_id", "recipe_step_id"], name: "recipe_snapshot_step"
    t.index ["recipe_step_id", "recipe_snapshot_id"], name: "recipe_step_snapshot"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.integer "number", null: false
    t.text "instruction", null: false
    t.integer "duration_sec"
    t.integer "max_before_sec"
    t.integer "min_before_sec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "output_name"
    t.boolean "removed", default: false, null: false
    t.index ["recipe_id", "removed"], name: "index_recipe_steps_on_recipe_id_and_removed"
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
    t.integer "current_price_cents"
    t.float "output_volume_weight_ratio"
    t.bigint "organization_id", null: false
    t.index ["organization_id", "name"], name: "index_recipes_on_organization_id_and_name"
    t.index ["organization_id", "publish"], name: "index_recipes_on_organization_id_and_publish"
  end

  create_table "step_inputs", force: :cascade do |t|
    t.bigint "recipe_step_id", null: false
    t.bigint "inputable_id", null: false
    t.string "inputable_type", null: false
    t.float "quantity", default: 1.0, null: false
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "removed", default: false, null: false
    t.index ["inputable_type", "inputable_id"], name: "index_step_inputs_on_inputable_type_and_inputable_id"
    t.index ["recipe_step_id", "removed"], name: "index_step_inputs_on_recipe_step_id_and_removed"
  end

  create_table "tools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_organizations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.string "role", null: false
    t.bigint "kitchen_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "access_link"
    t.index ["auth_token"], name: "index_user_organizations_on_auth_token", unique: true
    t.index ["organization_id", "user_id"], name: "organizations_users_idx"
    t.index ["user_id", "organization_id"], name: "users_organizations_idx"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["organization_id"], name: "index_vendors_on_organization_id"
  end

end
