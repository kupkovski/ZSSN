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

ActiveRecord::Schema[8.0].define(version: 2025_05_23_235205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "infected_user_reports", force: :cascade do |t|
    t.bigint "suspect_id", null: false
    t.bigint "reporter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reporter_id"], name: "index_infected_user_reports_on_reporter_id"
    t.index ["suspect_id"], name: "index_infected_user_reports_on_suspect_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_inventory_items_on_inventory_id"
    t.index ["item_id"], name: "index_inventory_items_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "birthdate"
    t.string "gender"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "infected_user_reports", "users", column: "reporter_id"
  add_foreign_key "infected_user_reports", "users", column: "suspect_id"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventory_items", "inventories"
  add_foreign_key "inventory_items", "items"
end
