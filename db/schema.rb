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

ActiveRecord::Schema.define(version: 20170916003404) do

  create_table "factions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fleets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "quantity"
    t.bigint "unit_id"
    t.bigint "squad_id"
    t.bigint "planet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id"
    t.integer "carrier_id"
    t.integer "destination_id"
    t.integer "arrive_in"
    t.index ["planet_id"], name: "index_fleets_on_planet_id"
    t.index ["squad_id"], name: "index_fleets_on_squad_id"
    t.index ["unit_id"], name: "index_fleets_on_unit_id"
  end

  create_table "planets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "sector"
    t.bigint "population"
    t.integer "credits"
    t.integer "metals"
    t.integer "rare_elements"
    t.string "domination"
    t.integer "x"
    t.integer "y"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "phase", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "vector_a"
    t.integer "vector_b"
    t.integer "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "credits"
    t.integer "metals"
    t.integer "rare_elements"
    t.string "url"
    t.boolean "ready"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faction_id"
  end

  create_table "units", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.integer "load_weigth"
    t.integer "load_capacity"
    t.boolean "groupable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fleets", "planets"
  add_foreign_key "fleets", "squads"
  add_foreign_key "fleets", "units"
end
