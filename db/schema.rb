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

ActiveRecord::Schema[8.1].define(version: 2026_11_26_172642) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.integer "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.string "namespace"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "factions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "fleets", force: :cascade do |t|
    t.boolean "ai"
    t.integer "armament_id"
    t.integer "arrives_in"
    t.integer "carrier_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.integer "destination_id"
    t.integer "level"
    t.integer "planet_id"
    t.integer "quantity"
    t.integer "ready_in"
    t.integer "round_id"
    t.integer "squad_id"
    t.integer "unit_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["planet_id"], name: "index_fleets_on_planet_id"
    t.index ["squad_id"], name: "index_fleets_on_squad_id"
    t.index ["unit_id"], name: "index_fleets_on_unit_id"
  end

  create_table "planets", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "credits"
    t.string "domination"
    t.string "name"
    t.integer "population", limit: 8
    t.integer "sector"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "x"
    t.integer "y"
  end

  create_table "results", force: :cascade do |t|
    t.integer "armament_id"
    t.integer "arrives_in"
    t.integer "blasted"
    t.boolean "blocked"
    t.integer "captor_id"
    t.integer "captured"
    t.integer "carrier_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.integer "destination_id"
    t.integer "final_quantity"
    t.integer "fled"
    t.integer "fleet_id"
    t.integer "level"
    t.integer "planet_id"
    t.integer "quantity"
    t.integer "ready_in"
    t.integer "round_id"
    t.integer "squad_id"
    t.integer "unit_id"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "phase", default: 0
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "distance"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "vector_a"
    t.integer "vector_b"
    t.boolean "wormhole"
  end

  create_table "setups", force: :cascade do |t|
    t.boolean "ai"
    t.integer "ai_level"
    t.string "builder_unit"
    t.integer "initial_credits"
    t.integer "initial_planets"
    t.integer "initial_wormholes"
    t.integer "minimum_fleet_for_build"
    t.integer "minimum_fleet_for_dominate"
    t.integer "planet_income_ratio"
    t.integer "upgrade_cost"
  end

  create_table "squads", force: :cascade do |t|
    t.boolean "ai"
    t.integer "ai_level"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.integer "credits", default: 0
    t.integer "faction_id"
    t.integer "map_ratio", default: 100
    t.integer "metals"
    t.string "name"
    t.integer "rare_elements"
    t.boolean "ready"
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
  end

  create_table "units", force: :cascade do |t|
    t.integer "acceleration", default: 0, null: false
    t.string "acronym"
    t.boolean "armable"
    t.integer "armor_class", default: 1, null: false
    t.boolean "armory"
    t.integer "capacity"
    t.boolean "carriable"
    t.integer "command_bonus", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.integer "credits"
    t.string "description"
    t.integer "faction_mask"
    t.integer "force_power", default: 0, null: false
    t.boolean "groupable"
    t.integer "hull"
    t.integer "hyperdrive", default: 0
    t.integer "influence_ratio"
    t.integer "ion_attack", default: 0, null: false
    t.integer "laser_attack", default: 0, null: false
    t.integer "maneuverability", default: 0, null: false
    t.integer "morale", default: 75, null: false
    t.string "name"
    t.integer "ordnance_attack", default: 0, null: false
    t.integer "producing_time"
    t.integer "rank", default: 0, null: false
    t.integer "shield"
    t.integer "siege_power", default: 0, null: false
    t.integer "speed", default: 0, null: false
    t.string "terrain"
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "weight"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "squad_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
