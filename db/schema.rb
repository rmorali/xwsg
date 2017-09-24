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

ActiveRecord::Schema.define(version: 20170921151435) do

  create_table "factions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fleets", force: :cascade do |t|
    t.integer "quantity"
    t.integer "unit_id"
    t.integer "squad_id"
    t.integer "planet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id"
    t.integer "carrier_id"
    t.integer "destination_id"
    t.integer "arrives_in"
    t.integer "ready_in"
    t.index ["planet_id"], name: "index_fleets_on_planet_id"
    t.index ["squad_id"], name: "index_fleets_on_squad_id"
    t.index ["unit_id"], name: "index_fleets_on_unit_id"
  end

  create_table "planets", force: :cascade do |t|
    t.string "name"
    t.integer "sector"
    t.integer "population", limit: 8
    t.integer "credits"
    t.integer "metals"
    t.integer "rare_elements"
    t.string "domination"
    t.integer "x"
    t.integer "y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "phase", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", force: :cascade do |t|
    t.integer "vector_a"
    t.integer "vector_b"
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squads", force: :cascade do |t|
    t.string "name"
    t.integer "credits"
    t.integer "metals"
    t.integer "rare_elements"
    t.string "url"
    t.boolean "ready"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faction_id"
    t.string "color"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.string "type"
    t.string "terrain"
    t.integer "faction_mask"
    t.integer "hyperdrive"
    t.integer "credits"
    t.integer "metals"
    t.integer "rare_elements"
    t.integer "producing_time"
    t.integer "weight"
    t.integer "capacity"
    t.boolean "groupable"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "squad_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
