# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131231005853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "zip_code"
    t.float    "balance",                default: 0.0
    t.date     "admission_date"
    t.integer  "client_type_id"
    t.string   "state",                  default: "Mendoza"
    t.string   "country",                default: "Argentina"
    t.string   "phone_one"
    t.string   "phone_two"
    t.string   "email_one"
    t.boolean  "responsible_registered", default: false
    t.string   "cuit"
    t.float    "discount",               default: 0.0
    t.datetime "last_transaction_at"
  end

  create_table "delivery_note_items", force: :cascade do |t|
    t.integer  "delivery_note_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "delivery_notes", force: :cascade do |t|
    t.integer  "client_id"
    t.text     "comments"
    t.integer  "state",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "formula_elements", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.float    "min_stock",     default: 1.0
    t.float    "current_stock", default: 0.0
    t.boolean  "infinite"
  end

  create_table "formula_items", force: :cascade do |t|
    t.integer  "formula_id"
    t.integer  "formula_element_id"
    t.decimal  "proportion"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "formulas", force: :cascade do |t|
    t.string   "name"
    t.string   "abrasive"
    t.string   "grain"
    t.string   "hardness"
    t.string   "porosity"
    t.string   "alloy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "making_order_formula_items", force: :cascade do |t|
    t.integer  "making_order_formula_id"
    t.integer  "formula_item_id"
    t.integer  "formula_element_id"
    t.string   "formula_element_name"
    t.decimal  "proportion"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.decimal  "consumed_stock"
  end

  create_table "making_order_formulas", force: :cascade do |t|
    t.integer  "formula_id"
    t.integer  "making_order_id"
    t.string   "formula_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "formula_abrasive"
    t.string   "formula_grain"
    t.string   "formula_hardness"
    t.string   "formula_porosity"
    t.string   "formula_alloy"
  end

  create_table "making_order_items", force: :cascade do |t|
    t.integer  "making_order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "product_name"
    t.string   "product_shape"
    t.string   "product_size"
    t.decimal  "product_weight"
    t.string   "product_pressure"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "making_orders", force: :cascade do |t|
    t.decimal  "total_weight"
    t.decimal  "weight_per_round"
    t.integer  "rounds_count"
    t.text     "comments"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "mixer_capacity",   default: 60.0
    t.integer  "state",            default: 0
  end

  create_table "production_months", force: :cascade do |t|
    t.integer  "year"
    t.integer  "month"
    t.decimal  "production", default: "0.0"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price"
    t.integer  "formula_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "shape"
    t.string   "size"
    t.decimal  "weight"
    t.string   "pressure"
  end

end
