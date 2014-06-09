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

ActiveRecord::Schema.define(version: 20140609033303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "tag_name"
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_records", force: true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "record_num"
    t.integer  "score"
    t.boolean  "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "bracket"
    t.integer  "round"
    t.integer  "match"
    t.boolean  "bye"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",          default: "Winner"
  end

  create_table "players", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "seed"
    t.string   "name"
    t.string   "group"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tournaments", force: true do |t|
    t.integer  "user_id"
    t.integer  "size"
    t.string   "type",              default: "SingleElimination"
    t.string   "title"
    t.string   "place"
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "consolation_round", default: true
    t.string   "url"
    t.boolean  "secondary_final",   default: false
    t.boolean  "scoreless",         default: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
