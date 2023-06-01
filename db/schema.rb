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

ActiveRecord::Schema[7.0].define(version: 2023_05_31_185634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.bigint "place_id", null: false
    t.time "start_time"
    t.time "end_time"
    t.integer "counter"
    t.text "directions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_events_on_itinerary_id"
    t.index ["place_id"], name: "index_events_on_place_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interests_places", id: false, force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "interest_id", null: false
  end

  create_table "itineraries", force: :cascade do |t|
    t.text "address"
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.integer "budget"
    t.string "interests", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "places", force: :cascade do |t|
    t.bigint "itinerary_id", null: false
    t.text "name"
    t.text "description"
    t.text "address"
    t.text "opening_hours"
    t.text "phone"
    t.text "map_static"
    t.text "map_link"
    t.text "review_count"
    t.text "review_samples"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "rating"
    t.string "image"
    t.float "latitude"
    t.float "longitude"
    t.index ["itinerary_id"], name: "index_places_on_itinerary_id"
  end

  add_foreign_key "events", "itineraries"
  add_foreign_key "events", "places"
  add_foreign_key "places", "itineraries"
end
