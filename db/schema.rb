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

ActiveRecord::Schema[8.0].define(version: 2025_05_22_003333) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.string "action", null: false
    t.jsonb "audited_changes", default: {}, null: false
    t.string "audited_fields", default: [], null: false, array: true
    t.bigint "user_id"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_audit_logs_on_auditable_type_and_auditable_id"
    t.index ["audited_fields"], name: "index_audit_logs_on_audited_fields", using: :gin
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "tax_identification", null: false
    t.string "address"
    t.string "zipcode"
    t.string "country"
    t.string "province"
    t.string "maps_url"
    t.string "phone"
    t.string "email"
    t.integer "client_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tax_type"
    t.string "seller_name"
    t.text "comments_plain_text"
    t.index ["tax_identification"], name: "index_clients_on_tax_identification", unique: true
  end

  create_table "discounts", force: :cascade do |t|
    t.integer "discount_type", null: false
    t.integer "client_type"
    t.decimal "percentage", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_type"], name: "index_discounts_on_client_type"
    t.index ["discount_type"], name: "index_discounts_on_discount_type"
  end

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

  create_table "maintenance_tasks_runs", force: :cascade do |t|
    t.string "task_name", null: false
    t.datetime "started_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.float "time_running", default: 0.0, null: false
    t.bigint "tick_count", default: 0, null: false
    t.bigint "tick_total"
    t.string "job_id"
    t.string "cursor"
    t.string "status", default: "enqueued", null: false
    t.string "error_class"
    t.string "error_message"
    t.text "backtrace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "arguments"
    t.integer "lock_version", default: 0, null: false
    t.text "metadata"
    t.index ["task_name", "status", "created_at"], name: "index_maintenance_tasks_runs", order: { created_at: :desc }
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
    t.text "comments_plain_text"
    t.float "mixer_capacity", default: 60.0
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manufactured_products", force: :cascade do |t|
    t.bigint "formula_id"
    t.string "pressure"
    t.string "shape"
    t.string "size"
    t.decimal "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formula_id"], name: "index_manufactured_products_on_formula_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "productable_type"
    t.integer "productable_id"
    t.integer "current_stock", default: 0, null: false
    t.integer "min_stock", default: 0, null: false
    t.integer "max_stock", default: 0, null: false
    t.bigint "supplier_id"
    t.text "comments_plain_text"
    t.index ["productable_type", "productable_id"], name: "index_products_on_productable_type_and_productable_id"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "purchased_products", force: :cascade do |t|
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

  create_table "supplier_products", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.bigint "product_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_supplier_products_on_product_id"
    t.index ["supplier_id"], name: "index_supplier_products_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
    t.string "tax_identification", null: false
    t.string "address"
    t.string "country"
    t.string "province"
    t.string "zipcode"
    t.string "maps_url"
    t.string "phone"
    t.string "email"
    t.string "bank_name"
    t.string "bank_account_number"
    t.string "routing_number"
    t.integer "tax_type", default: 0
    t.text "comments_plain_text"
    t.boolean "in_house", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tax_identification"], name: "index_suppliers_on_tax_identification", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "manufactured_products", "formulas"
  add_foreign_key "products", "suppliers"
  add_foreign_key "sessions", "users"
  add_foreign_key "supplier_products", "products"
  add_foreign_key "supplier_products", "suppliers"
end
