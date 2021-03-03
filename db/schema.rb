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

ActiveRecord::Schema.define(version: 2021_02_25_225116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crisis_events", force: :cascade do |t|
    t.text "additional_info"
    t.boolean "closed"
    t.bigint "team_member_id"
    t.datetime "closed_at"
    t.bigint "user_id", null: false
    t.bigint "crisis_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["crisis_type_id"], name: "index_crisis_events_on_crisis_type_id"
    t.index ["team_member_id"], name: "index_crisis_events_on_team_member_id"
    t.index ["user_id"], name: "index_crisis_events_on_user_id"
  end

  create_table "crisis_notes", force: :cascade do |t|
    t.text "content"
    t.bigint "crisis_event_id", null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["crisis_event_id"], name: "index_crisis_notes_on_crisis_event_id"
    t.index ["team_member_id"], name: "index_crisis_notes_on_team_member_id"
  end

  create_table "crisis_types", force: :cascade do |t|
    t.string "type"
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_crisis_types_on_team_member_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.boolean "visible_to_user"
    t.bigint "team_member_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_notes_on_team_member_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_team_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_team_members_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "mobile_number"
    t.datetime "release_date"
    t.boolean "terms", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wba_self_permissions", force: :cascade do |t|
    t.bigint "wba_self_id", null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wba_self_permissions_on_team_member_id"
    t.index ["wba_self_id"], name: "index_wba_self_permissions_on_wba_self_id"
  end

  create_table "wba_self_scores", force: :cascade do |t|
    t.integer "value"
    t.integer "priority"
    t.bigint "wba_self_id", null: false
    t.bigint "wellbeing_metric_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wba_self_id"], name: "index_wba_self_scores_on_wba_self_id"
    t.index ["wellbeing_metric_id"], name: "index_wba_self_scores_on_wellbeing_metric_id"
  end

  create_table "wba_self_view_logs", force: :cascade do |t|
    t.bigint "wba_self_id", null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wba_self_view_logs_on_team_member_id"
    t.index ["wba_self_id"], name: "index_wba_self_view_logs_on_wba_self_id"
  end

  create_table "wba_selves", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_wba_selves_on_user_id"
  end

  create_table "wba_team_member_scores", force: :cascade do |t|
    t.integer "value"
    t.integer "priority"
    t.bigint "wba_team_member_id", null: false
    t.bigint "wellbeing_metric_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wba_team_member_id"], name: "index_wba_team_member_scores_on_wba_team_member_id"
    t.index ["wellbeing_metric_id"], name: "index_wba_team_member_scores_on_wellbeing_metric_id"
  end

  create_table "wba_team_members", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wba_team_members_on_team_member_id"
    t.index ["user_id"], name: "index_wba_team_members_on_user_id"
  end

  create_table "wellbeing_metrics", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wellbeing_metrics_on_team_member_id"
  end

  add_foreign_key "crisis_events", "crisis_types"
  add_foreign_key "crisis_events", "users"
  add_foreign_key "crisis_notes", "crisis_events"
  add_foreign_key "crisis_notes", "team_members"
  add_foreign_key "crisis_types", "team_members"
  add_foreign_key "notes", "team_members"
  add_foreign_key "notes", "users"
  add_foreign_key "wba_self_permissions", "team_members"
  add_foreign_key "wba_self_permissions", "wba_selves"
  add_foreign_key "wba_self_scores", "wba_selves"
  add_foreign_key "wba_self_scores", "wellbeing_metrics"
  add_foreign_key "wba_self_view_logs", "team_members"
  add_foreign_key "wba_self_view_logs", "wba_selves"
  add_foreign_key "wba_selves", "users"
  add_foreign_key "wba_team_member_scores", "wba_team_members"
  add_foreign_key "wba_team_member_scores", "wellbeing_metrics"
  add_foreign_key "wba_team_members", "team_members"
  add_foreign_key "wba_team_members", "users"
  add_foreign_key "wellbeing_metrics", "team_members"
end
