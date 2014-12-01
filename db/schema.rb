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

ActiveRecord::Schema.define(version: 20141201032358) do

  create_table "airlines", force: true do |t|
    t.string   "name"
    t.string   "iata"
    t.string   "icao"
    t.string   "callsign"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "routes_count", default: 0, null: false
  end

  create_table "airports", force: true do |t|
    t.string   "name"
    t.string   "iata_faa"
    t.string   "icao"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "altitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "departing_flights_count", default: 0, null: false
    t.integer  "arriving_flights_count",  default: 0, null: false
  end

  create_table "routes", force: true do |t|
    t.integer  "airline_id"
    t.integer  "origin_airport_id"
    t.integer  "destination_airport_id"
    t.integer  "stops"
    t.string   "equipment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
