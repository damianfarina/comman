# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_15_231022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "formula_elements", force: :cascade do |t|
    t.string "name"
    t.float "min_stock", default: 1.0
    t.float "current_stock", default: 0.0
    t.boolean "infinite", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formula_items", force: :cascade do |t|
    t.integer "formula_id"
    t.integer "formula_element_id"
    t.decimal "proportion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formulas", force: :cascade do |t|
    t.string "name"
    t.string "abrasive"
    t.string "grain"
    t.string "hardness"
    t.string "porosity"
    t.string "alloy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "making_order_formula_items", force: :cascade do |t|
    t.integer "making_order_formula_id"
    t.integer "formula_item_id"
    t.integer "formula_element_id"
    t.string "formula_element_name"
    t.decimal "proportion"
    t.decimal "consumed_stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "making_order_formulas", force: :cascade do |t|
    t.integer "formula_id"
    t.integer "making_order_id"
    t.string "formula_name"
    t.string "formula_abrasive"
    t.string "formula_grain"
    t.string "formula_hardness"
    t.string "formula_porosity"
    t.string "formula_alloy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "making_order_items", force: :cascade do |t|
    t.integer "making_order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.string "product_name"
    t.string "product_shape"
    t.string "product_size"
    t.decimal "product_weight"
    t.string "product_pressure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "making_orders", force: :cascade do |t|
    t.decimal "total_weight"
    t.decimal "weight_per_round"
    t.integer "rounds_count"
    t.text "comments"
    t.float "mixer_capacity", default: 60.0
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "formula_id"
    t.string "shape"
    t.string "size"
    t.decimal "weight"
    t.string "pressure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
