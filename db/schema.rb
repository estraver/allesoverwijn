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

ActiveRecord::Schema.define(version: 20151219195318) do

  create_table "address_profiles", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "profile_id"
    t.string   "address_type", null: false
    t.date     "valid_from"
    t.date     "valid_to"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "address_profiles", ["address_id"], name: "index_address_profiles_on_address_id"
  add_index "address_profiles", ["profile_id"], name: "index_address_profiles_on_profile_id"

  create_table "addresses", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "city"
    t.string   "country_province"
    t.string   "zip_or_postcode"
    t.string   "country",               limit: 3
    t.string   "other_address_details"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "auth_meta_data", force: :cascade do |t|
    t.string   "password_digest",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_created_at"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "user_id",                              null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "birth_place"
    t.string   "home",          limit: 3
    t.integer  "gender",                  default: 0
    t.text     "bio"
    t.string   "country",       limit: 3
    t.string   "language",      limit: 2
    t.binary   "photo"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "role_meta_data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true

  create_table "setting_contents", force: :cascade do |t|
    t.string   "value",                null: false
    t.string   "locale",     limit: 2, null: false
    t.integer  "setting_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "setting_contents", ["setting_id"], name: "index_setting_contents_on_setting_id"

  create_table "settings", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "namespace",  null: false
    t.string   "value_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "translation_keys", force: :cascade do |t|
    t.string   "key",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translation_keys", ["key"], name: "index_translation_keys_on_key"

  create_table "translation_texts", force: :cascade do |t|
    t.text     "text"
    t.string   "locale"
    t.integer  "translation_key_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translation_texts", ["translation_key_id"], name: "index_translation_texts_on_translation_key_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",              default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "auth_meta_data"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end
