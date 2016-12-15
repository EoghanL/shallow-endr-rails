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

ActiveRecord::Schema.define(version: 20161214211352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "display_name"
    t.string   "mb_id"
    t.string   "description"
    t.string   "image"
    t.string   "start_date"
  end

  create_table "future_songs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "song_mb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "song_id"
    t.string   "name"
  end

  create_table "rankings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.integer  "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "weight"
  end

  create_table "songs", force: :cascade do |t|
    t.string   "name"
    t.integer  "artist_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "mb_id"
    t.string   "album_id"
    t.string   "artist_mb_id"
    t.integer  "current_weight"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "last_name"
  end

  create_table "users_artists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "artist_id"
    t.integer  "song_one_id"
    t.integer  "song_two_id"
    t.integer  "song_three_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
