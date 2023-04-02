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

ActiveRecord::Schema[7.0].define(version: 2023_04_01_165334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authentication_credentials", force: :cascade do |t|
    t.string "username", null: false
    t.text "password_digest", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_authentication_credentials_on_owner_id_and_owner_type", unique: true
    t.index ["username"], name: "index_authentication_credentials_on_username", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.uuid "external_id", default: -> { "gen_random_uuid()" }, null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_organizations_on_external_id", unique: true
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "shifts", force: :cascade do |t|
    t.uuid "external_id", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "worker_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.date "local_start_date", null: false
    t.date "local_end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_shifts_on_external_id", unique: true
    t.index ["worker_id", "local_end_date"], name: "index_shifts_on_worker_id_and_local_end_date", unique: true
    t.index ["worker_id", "local_start_date"], name: "index_shifts_on_worker_id_and_local_start_date", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.uuid "external_id", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "organization_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", null: false
    t.index ["external_id"], name: "index_workers_on_external_id", unique: true
    t.index ["organization_id"], name: "index_workers_on_organization_id"
  end

  add_foreign_key "shifts", "workers"
  add_foreign_key "workers", "organizations"
end
