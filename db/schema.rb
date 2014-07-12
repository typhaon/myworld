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

ActiveRecord::Schema.define(version: 20140707151555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cells", force: true do |t|
    t.integer  "row",        null: false
    t.integer  "column",     null: false
    t.integer  "terrain_id", null: false
    t.integer  "world_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terrains", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "worlds", force: true do |t|
    t.string   "name",        null: false
    t.integer  "max_rows",    null: false
    t.integer  "max_columns", null: false
    t.string   "cells",                    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
