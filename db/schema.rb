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

ActiveRecord::Schema[8.1].define(version: 2026_08_13_210300) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "city", limit: 80
    t.string "country_code", limit: 2, default: "US", null: false
    t.datetime "created_at", null: false
    t.string "line_1", limit: 120
    t.string "line_2", limit: 120
    t.string "postal_code", limit: 20
    t.string "state", limit: 80
    t.datetime "updated_at", null: false
    t.index ["postal_code", "country_code"], name: "index_addresses_on_postal_code_and_country_code"
  end

  create_table "attorney_profiles", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "address_id"
    t.string "bar_number", limit: 80
    t.boolean "court_appointed", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", limit: 254
    t.string "firm_name", limit: 180
    t.string "job_title", limit: 100
    t.string "licensing_state", limit: 2
    t.jsonb "metadata", default: {}, null: false
    t.string "phone", limit: 40
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["address_id"], name: "index_attorney_profiles_on_address_id"
    t.index ["licensing_state", "bar_number"], name: "index_attorney_profiles_on_license", unique: true, where: "(bar_number IS NOT NULL)"
    t.index ["user_id"], name: "index_attorney_profiles_on_user_id", unique: true
  end

  create_table "case_documents", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.date "authored_on"
    t.uuid "case_id", null: false
    t.boolean "confidential", default: false, null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.text "description"
    t.string "document_number", limit: 100
    t.string "document_type", limit: 40, null: false
    t.datetime "filed_at"
    t.uuid "filed_by_participant_id"
    t.jsonb "metadata", default: {}, null: false
    t.datetime "received_at"
    t.datetime "served_at"
    t.string "status", limit: 32, default: "draft", null: false
    t.string "title", limit: 180, null: false
    t.datetime "updated_at", null: false
    t.index ["case_id", "document_number"], name: "index_case_documents_on_case_id_and_document_number"
    t.index ["case_id", "document_type"], name: "index_case_documents_on_case_id_and_document_type"
    t.index ["case_id", "filed_at"], name: "index_case_documents_on_case_id_and_filed_at"
    t.index ["case_id"], name: "index_case_documents_on_case_id"
    t.index ["created_by_id"], name: "index_case_documents_on_created_by_id"
    t.index ["filed_by_participant_id"], name: "index_case_documents_on_filed_by_participant_id"
  end

  create_table "case_events", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.boolean "all_day", default: false, null: false
    t.uuid "case_id", null: false
    t.boolean "confidential", default: false, null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.text "description"
    t.datetime "ends_at"
    t.string "event_type", limit: 40, null: false
    t.string "location", limit: 180
    t.jsonb "metadata", default: {}, null: false
    t.string "source", limit: 180
    t.datetime "starts_at", null: false
    t.string "status", limit: 32, default: "scheduled", null: false
    t.string "title", limit: 180, null: false
    t.datetime "updated_at", null: false
    t.index ["case_id", "event_type"], name: "index_case_events_on_case_id_and_event_type"
    t.index ["case_id", "starts_at"], name: "index_case_events_on_case_id_and_starts_at"
    t.index ["case_id"], name: "index_case_events_on_case_id"
    t.index ["created_by_id"], name: "index_case_events_on_created_by_id"
    t.index ["status", "starts_at"], name: "index_case_events_on_status_and_starts_at"
  end

  create_table "case_issues", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "asserted_by_participant_id"
    t.uuid "case_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "disposed_on"
    t.string "disposition", limit: 100
    t.string "issue_type", limit: 32, null: false
    t.jsonb "metadata", default: {}, null: false
    t.integer "position", default: 1, null: false
    t.string "status", limit: 32, default: "open", null: false
    t.string "statute_code", limit: 120
    t.string "title", limit: 180, null: false
    t.datetime "updated_at", null: false
    t.index ["asserted_by_participant_id"], name: "index_case_issues_on_asserted_by_participant_id"
    t.index ["case_id", "issue_type", "status"], name: "index_case_issues_on_case_id_and_issue_type_and_status"
    t.index ["case_id", "position"], name: "index_case_issues_on_case_id_and_position"
    t.index ["case_id"], name: "index_case_issues_on_case_id"
  end

  create_table "case_participants", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "address_id"
    t.uuid "attorney_profile_id"
    t.boolean "confidential", default: false, null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.date "date_of_birth"
    t.date "date_of_death"
    t.string "display_name", limit: 180, null: false
    t.string "email", limit: 254
    t.string "first_name", limit: 80
    t.jsonb "identifiers", default: {}, null: false
    t.string "last_name", limit: 80
    t.jsonb "metadata", default: {}, null: false
    t.string "middle_name", limit: 80
    t.string "name_suffix", limit: 20
    t.string "organization_name", limit: 180
    t.string "participant_type", limit: 32, null: false
    t.string "phone", limit: 40
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index "lower((display_name)::text)", name: "index_case_participants_on_lower_name"
    t.index ["address_id"], name: "index_case_participants_on_address_id"
    t.index ["attorney_profile_id"], name: "index_case_participants_on_attorney_profile_id"
    t.index ["created_by_id"], name: "index_case_participants_on_created_by_id"
    t.index ["participant_type"], name: "index_case_participants_on_participant_type"
    t.index ["user_id"], name: "index_case_participants_on_user_id"
  end

  create_table "case_participations", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "case_id", null: false
    t.uuid "case_participant_id", null: false
    t.datetime "created_at", null: false
    t.string "role", limit: 40
    t.datetime "updated_at", null: false
    t.index ["case_id", "case_participant_id"], name: "index_case_participations_uniquely", unique: true
    t.index ["case_id", "role"], name: "index_case_participations_on_case_id_and_role"
    t.index ["case_id"], name: "index_case_participations_on_case_id"
    t.index ["case_participant_id"], name: "index_case_participations_on_case_participant_id"
  end

  create_table "cases", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.string "case_number", limit: 100, null: false
    t.string "case_type", limit: 32, null: false
    t.jsonb "charges", default: [], null: false
    t.date "closed_on"
    t.boolean "confidential", default: false, null: false
    t.string "court_division", limit: 100
    t.uuid "courthouse_id"
    t.datetime "created_at", null: false
    t.uuid "created_by_id", null: false
    t.text "description"
    t.date "filed_on"
    t.string "judge_name", limit: 120
    t.integer "lock_version", default: 0, null: false
    t.jsonb "metadata", default: {}, null: false
    t.datetime "next_event_at"
    t.date "start_date", null: false
    t.string "status", limit: 32, default: "active", null: false
    t.text "summary"
    t.string "title", limit: 180, null: false
    t.datetime "updated_at", null: false
    t.index "lower((case_number)::text)", name: "index_cases_on_lower_case_number"
    t.index "lower((title)::text)", name: "index_cases_on_lower_title"
    t.index ["case_number"], name: "index_cases_on_case_number"
    t.index ["case_type", "status"], name: "index_cases_on_case_type_and_status"
    t.index ["charges"], name: "index_cases_on_charges", using: :gin
    t.index ["courthouse_id"], name: "index_cases_on_courthouse_id"
    t.index ["created_by_id"], name: "index_cases_on_created_by_id"
    t.index ["next_event_at"], name: "index_cases_on_next_event_at"
    t.index ["start_date"], name: "index_cases_on_start_date"
  end

  create_table "courthouses", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "address_id", null: false
    t.datetime "created_at", null: false
    t.uuid "created_by_id"
    t.string "homepage", limit: 200
    t.string "jurisdiction", limit: 80, null: false
    t.string "name", limit: 80, null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_courthouses_on_lower_name", unique: true
    t.index ["address_id"], name: "index_courthouses_on_address_id"
    t.index ["created_by_id"], name: "index_courthouses_on_created_by_id"
  end

  create_table "users", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "address_id"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "name"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "attorney_profiles", "addresses", on_delete: :restrict
  add_foreign_key "attorney_profiles", "users", on_delete: :cascade
  add_foreign_key "case_documents", "case_participants", column: "filed_by_participant_id", on_delete: :nullify
  add_foreign_key "case_documents", "cases", on_delete: :cascade
  add_foreign_key "case_documents", "users", column: "created_by_id", on_delete: :nullify
  add_foreign_key "case_events", "cases", on_delete: :cascade
  add_foreign_key "case_events", "users", column: "created_by_id", on_delete: :nullify
  add_foreign_key "case_issues", "case_participants", column: "asserted_by_participant_id", on_delete: :nullify
  add_foreign_key "case_issues", "cases", on_delete: :cascade
  add_foreign_key "case_participants", "addresses", on_delete: :restrict
  add_foreign_key "case_participants", "attorney_profiles", on_delete: :nullify
  add_foreign_key "case_participants", "users", column: "created_by_id", on_delete: :nullify
  add_foreign_key "case_participants", "users", on_delete: :nullify
  add_foreign_key "case_participations", "case_participants", on_delete: :cascade
  add_foreign_key "case_participations", "cases", on_delete: :cascade
  add_foreign_key "cases", "courthouses", on_delete: :nullify
  add_foreign_key "cases", "users", column: "created_by_id", on_delete: :restrict
  add_foreign_key "courthouses", "addresses", on_delete: :restrict
  add_foreign_key "courthouses", "users", column: "created_by_id"
  add_foreign_key "users", "addresses", on_delete: :restrict
end
