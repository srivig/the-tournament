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

ActiveRecord::Schema.define(version: 20170318131842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "tag_name",      limit: 255
    t.string   "category_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_records", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "record_num"
    t.integer  "score"
    t.boolean  "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_records", ["game_id", "player_id"], name: "index_game_records_on_game_id_and_player_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "bracket"
    t.integer  "round"
    t.integer  "match"
    t.boolean  "bye"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",          limit: 255, default: "Winner"
    t.string   "comment",       limit: 24
  end

  add_index "games", ["tournament_id"], name: "index_games_on_tournament_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "count",      null: false
    t.integer  "size",       null: false
    t.date     "expires_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["expires_at"], name: "index_plans_on_expires_at", using: :btree
  add_index "plans", ["user_id"], name: "index_plans_on_user_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "seed"
    t.string   "name",          limit: 255
    t.string   "group",         limit: 255
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country",       limit: 255
  end

  add_index "players", ["tournament_id"], name: "index_players_on_tournament_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "size"
    t.string   "type",              limit: 255, default: "SingleElimination"
    t.string   "title",             limit: 255
    t.string   "place",             limit: 255
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "consolation_round",             default: true
    t.string   "url",               limit: 255
    t.boolean  "secondary_final",               default: false
    t.boolean  "scoreless",                     default: false
    t.boolean  "finished",                      default: false
    t.boolean  "pickup",                        default: false
    t.string   "facebook_album_id", limit: 255
  end

  add_index "tournaments", ["finished"], name: "index_tournaments_on_finished", using: :btree
  add_index "tournaments", ["pickup"], name: "index_tournaments_on_pickup", using: :btree
  add_index "tournaments", ["user_id"], name: "index_tournaments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.boolean  "email_subscription",                 default: true
    t.string   "name",                   limit: 255
    t.text     "profile"
    t.string   "url",                    limit: 255
    t.string   "facebook_url",           limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
