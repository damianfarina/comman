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

ActiveRecord::Schema[8.0].define(version: 2024_10_22_231333) do
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
end
