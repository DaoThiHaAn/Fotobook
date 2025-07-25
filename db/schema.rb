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

ActiveRecord::Schema[8.0].define(version: 2025_07_17_172934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "album_components", primary_key: ["album_id", "photo_id"], force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "photo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_album_components_on_album_id"
    t.index ["photo_id"], name: "index_album_components_on_photo_id"
  end

  create_table "albums", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.boolean "is_public"
    t.integer "hearts_count", default: 0
    t.integer "photos_count", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "image_path"
    t.text "title"
    t.text "description"
    t.boolean "is_public"
    t.integer "hearts_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", primary_key: "user_id", force: :cascade do |t|
    t.integer "photos_count", default: 0
    t.integer "albums_count", default: 0
    t.integer "followers_count", default: 0
    t.integer "followings_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "avatar"
    t.boolean "is_active", default: true
    t.boolean "is_admin", default: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
  end

  add_foreign_key "profiles", "users", on_delete: :cascade
end
