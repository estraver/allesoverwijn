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

ActiveRecord::Schema.define(version: 20160818054310) do

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

  create_table "blogs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "parent_category_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "categories", ["parent_category_id"], name: "index_categories_on_parent_category_id"

  create_table "categorization", id: false, force: :cascade do |t|
    t.integer "post_id",     null: false
    t.integer "category_id", null: false
  end

  add_index "categorization", ["category_id", "post_id"], name: "index_categorization_on_category_id_and_post_id"
  add_index "categorization", ["post_id", "category_id"], name: "index_categorization_on_post_id_and_category_id"

  create_table "category_names", force: :cascade do |t|
    t.string   "name",                  null: false
    t.string   "locale",      limit: 2, null: false
    t.integer  "category_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "category_names", ["category_id"], name: "index_category_names_on_category_id"

  create_table "network_accounts", force: :cascade do |t|
    t.string   "account",      null: false
    t.integer  "account_type", null: false
    t.integer  "profile_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "network_accounts", ["profile_id"], name: "index_network_accounts_on_profile_id"

  create_table "post_contents", force: :cascade do |t|
    t.string   "title",                                  null: false
    t.text     "article",                                null: false
    t.boolean  "published",              default: false
    t.date     "published_on"
    t.integer  "post_id"
    t.integer  "author_id"
    t.string   "locale",       limit: 2,                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "post_contents", ["author_id"], name: "index_post_contents_on_author_id"
  add_index "post_contents", ["post_id"], name: "index_post_contents_on_post_id"

  create_table "posts", force: :cascade do |t|
    t.integer  "page_id",           null: false
    t.string   "page_type",         null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.binary   "picture_meta_data"
  end

  add_index "posts", ["page_type", "page_id"], name: "index_posts_on_page_type_and_page_id"

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "birth_place"
    t.string   "home",            limit: 3
    t.integer  "gender",                    default: 0
    t.text     "bio"
    t.string   "country",         limit: 3
    t.string   "language",        limit: 2
    t.binary   "photo_meta_data"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string   "value"
    t.integer  "post_content_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
  end

  add_index "properties", ["post_content_id"], name: "index_properties_on_post_content_id"

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

  create_table "taggings", id: false, force: :cascade do |t|
    t.integer "post_content_id", null: false
    t.integer "tag_id",          null: false
  end

  add_index "taggings", ["post_content_id", "tag_id"], name: "index_taggings_on_post_content_id_and_tag_id"
  add_index "taggings", ["tag_id", "post_content_id"], name: "index_taggings_on_tag_id_and_post_content_id"

  create_table "tags", force: :cascade do |t|
    t.string   "tag",        null: false
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
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "posts_count"
  end

end
