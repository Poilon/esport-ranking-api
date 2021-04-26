# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_26_195631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "characters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.uuid "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "smashgg_id"
  end

  create_table "elo_by_times", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.uuid "player_id"
    t.integer "elo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "match_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "smashgg_id"
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "winner_player_id"
    t.uuid "loser_player_id"
    t.uuid "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vod_url"
    t.bigint "smashgg_id"
    t.boolean "played", default: false
    t.boolean "is_loser_bracket", default: false
    t.string "full_round_text"
    t.string "display_score"
    t.integer "round"
    t.datetime "date"
    t.boolean "teams"
  end

  create_table "player_characters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id"
    t.uuid "character_id"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id"
    t.uuid "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "smashgg_id"
    t.string "name"
    t.string "location"
    t.string "city"
    t.string "sub_state"
    t.string "state"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "twitter"
    t.string "youtube"
    t.string "wiki"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_mpgr_ranking"
    t.bigint "smashgg_user_id"
    t.integer "elo"
    t.string "twitch"
    t.string "steam"
    t.string "discord"
    t.string "mixer"
    t.string "profile_picture_url"
    t.boolean "hide"
    t.string "prefix"
    t.string "username"
    t.boolean "team"
    t.string "gender_pronoun"
  end

  create_table "results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "player_id"
    t.uuid "tournament_id"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribed_queries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "websocket_connection_id"
    t.string "result_hash"
    t.string "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "prefix"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.bigint "smashgg_id"
    t.string "smashgg_link_url"
    t.string "name"
    t.integer "weight"
    t.uuid "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "online"
    t.boolean "processed", default: false
    t.boolean "imported_matches", default: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "websocket_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "connection_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
