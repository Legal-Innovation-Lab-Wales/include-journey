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

ActiveRecord::Schema.define(version: 2023_01_30_130725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "entities", null: false
    t.date "starts_at"
    t.date "ends_at"
    t.integer "bronze_count", default: 0, null: false
    t.integer "silver_count", default: 0, null: false
    t.integer "gold_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "affirmations", force: :cascade do |t|
    t.string "text", null: false
    t.date "scheduled_date", null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scheduled_date"], name: "index_affirmations_on_scheduled_date", unique: true
    t.index ["team_member_id"], name: "index_affirmations_on_team_member_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_member_id"
    t.datetime "start"
    t.datetime "end"
    t.string "who_with"
    t.string "where"
    t.string "what"
    t.boolean "attended", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_appointments_on_team_member_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "number"
    t.string "email"
    t.text "description", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "goal_types", force: :cascade do |t|
    t.text "name", null: false
    t.text "emoji", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "goal_type_id", null: false
    t.text "goal", null: false
    t.boolean "short_term", default: true, null: false
    t.datetime "achieved_on"
    t.boolean "archived", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["goal_type_id"], name: "index_goals_on_goal_type_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.text "entry"
    t.text "feeling"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "journal_entry_permissions", force: :cascade do |t|
    t.bigint "journal_entry_id", null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["journal_entry_id"], name: "index_journal_entry_permissions_on_journal_entry_id"
    t.index ["team_member_id"], name: "index_journal_entry_permissions_on_team_member_id"
  end

  create_table "journal_entry_view_logs", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.bigint "journal_entry_id", null: false
    t.integer "view_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["journal_entry_id"], name: "index_journal_entry_view_logs_on_journal_entry_id"
    t.index ["team_member_id"], name: "index_journal_entry_view_logs_on_team_member_id"
  end

  create_table "metrics_services", force: :cascade do |t|
    t.bigint "wellbeing_service_id", null: false
    t.bigint "wellbeing_metric_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wellbeing_metric_id"], name: "index_metrics_services_on_wellbeing_metric_id"
    t.index ["wellbeing_service_id"], name: "index_metrics_services_on_wellbeing_service_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.boolean "visible_to_user", default: false, null: false
    t.bigint "team_member_id", null: false
    t.bigint "user_id", null: false
    t.bigint "replaced_by_id"
    t.bigint "replacing_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["replaced_by_id"], name: "index_notes_on_replaced_by_id"
    t.index ["replacing_id"], name: "index_notes_on_replacing_id"
    t.index ["team_member_id"], name: "index_notes_on_team_member_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "session_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer "answer"
    t.bigint "survey_question_id", null: false
    t.bigint "survey_response_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_question_id"], name: "index_survey_answers_on_survey_question_id"
    t.index ["survey_response_id"], name: "index_survey_answers_on_survey_response_id"
  end

  create_table "survey_comment_sections", force: :cascade do |t|
    t.text "label", default: "", null: false
    t.integer "order", null: false
    t.bigint "survey_section_id", null: false
    t.integer "total", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_section_id"], name: "index_survey_comment_sections_on_survey_section_id"
  end

  create_table "survey_comments", force: :cascade do |t|
    t.text "text"
    t.bigint "survey_comment_section_id", null: false
    t.bigint "survey_response_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_comment_section_id"], name: "index_survey_comments_on_survey_comment_section_id"
    t.index ["survey_response_id"], name: "index_survey_comments_on_survey_response_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.text "question", default: "", null: false
    t.integer "order", null: false
    t.bigint "survey_section_id", null: false
    t.integer "total", default: 0, null: false
    t.integer "answer0", default: 0, null: false
    t.integer "answer1", default: 0, null: false
    t.integer "answer2", default: 0, null: false
    t.integer "answer3", default: 0, null: false
    t.integer "answer4", default: 0, null: false
    t.integer "answer5", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_section_id"], name: "index_survey_questions_on_survey_section_id"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.datetime "submitted_at"
    t.bigint "survey_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_responses_on_survey_id"
    t.index ["user_id"], name: "index_survey_responses_on_user_id"
  end

  create_table "survey_sections", force: :cascade do |t|
    t.text "heading"
    t.integer "order", null: false
    t.bigint "survey_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_survey_sections_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.boolean "active", default: false, null: false
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_surveys_on_team_member_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag"
    t.bigint "team_member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_tags_on_team_member_id"
  end

  create_table "team_members", force: :cascade do |t|
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.bigint "mobile_number"
    t.boolean "approved", default: false
    t.boolean "admin", default: false
    t.boolean "terms", default: false
    t.boolean "suspended", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_team_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_team_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_team_members_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_team_members_on_unlock_token", unique: true
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.boolean "bronze_achieved", default: false, null: false
    t.boolean "silver_achieved", default: false, null: false
    t.boolean "gold_achieved", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_pins", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.bigint "user_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_user_pins_on_team_member_id"
    t.index ["user_id"], name: "index_user_pins_on_user_id"
  end

  create_table "user_profile_view_logs", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.bigint "user_id", null: false
    t.integer "view_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_user_profile_view_logs_on_team_member_id"
    t.index ["user_id"], name: "index_user_profile_view_logs_on_user_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "user_id"
    t.bigint "team_member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id", "user_id"], name: "index_user_tags_on_tag_id_and_user_id", unique: true
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["team_member_id"], name: "index_user_tags_on_team_member_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.bigint "mobile_number"
    t.boolean "terms", default: false
    t.datetime "deleted_at"
    t.datetime "date_of_birth"
    t.text "disabilities"
    t.string "ethnic_group"
    t.string "religion"
    t.string "sex"
    t.string "gender_identity"
    t.string "pronouns"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nomis_id"
    t.string "pnc_no"
    t.string "delius_no"
    t.date "enrolled_at"
    t.date "intervened_at"
    t.string "release_establishment"
    t.string "probation_area"
    t.string "local_authority"
    t.date "pilot_completed_at"
    t.date "pilot_withdrawn_at"
    t.string "withdrawn_reason"
    t.string "index_offence"
    t.boolean "deleted", default: false, null: false
    t.date "last_session_at"
    t.integer "sessions_streak", default: 0, null: false
    t.integer "sessions_count", default: 0, null: false
    t.integer "sessions_this_month_count", default: 0, null: false
    t.date "last_wellbeing_assessment_at"
    t.integer "wellbeing_assessments_count", default: 0, null: false
    t.integer "wellbeing_assessments_this_month_count", default: 0, null: false
    t.date "last_journal_entry_at"
    t.integer "journal_entries_count", default: 0, null: false
    t.integer "journal_entries_this_month_count", default: 0, null: false
    t.date "last_goal_achieved_at"
    t.integer "goals_achieved_count", default: 0, null: false
    t.integer "goals_achieved_this_month_count", default: 0, null: false
    t.integer "bronze_achievements_count", default: 0, null: false
    t.integer "silver_achievements_count", default: 0, null: false
    t.integer "gold_achievements_count", default: 0, null: false
    t.boolean "notifications_enabled", default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "wba_scores", force: :cascade do |t|
    t.integer "value"
    t.integer "priority"
    t.bigint "wellbeing_assessment_id", null: false
    t.bigint "wellbeing_metric_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["wellbeing_assessment_id"], name: "index_wba_scores_on_wellbeing_assessment_id"
    t.index ["wellbeing_metric_id"], name: "index_wba_scores_on_wellbeing_metric_id"
  end

  create_table "wellbeing_assessments", force: :cascade do |t|
    t.bigint "team_member_id"
    t.bigint "user_id", null: false
    t.decimal "average"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wellbeing_assessments_on_team_member_id"
    t.index ["user_id"], name: "index_wellbeing_assessments_on_user_id"
  end

  create_table "wellbeing_metrics", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "icon"
    t.bigint "team_member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wellbeing_metrics_on_team_member_id"
  end

  create_table "wellbeing_score_values", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wellbeing_services", force: :cascade do |t|
    t.bigint "team_member_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "website", null: false
    t.bigint "contact_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_member_id"], name: "index_wellbeing_services_on_team_member_id"
  end

  add_foreign_key "affirmations", "team_members"
  add_foreign_key "appointments", "team_members"
  add_foreign_key "appointments", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "goals", "goal_types"
  add_foreign_key "goals", "users"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "journal_entry_permissions", "journal_entries"
  add_foreign_key "journal_entry_permissions", "team_members"
  add_foreign_key "journal_entry_view_logs", "journal_entries"
  add_foreign_key "journal_entry_view_logs", "team_members"
  add_foreign_key "metrics_services", "wellbeing_metrics"
  add_foreign_key "metrics_services", "wellbeing_services"
  add_foreign_key "notes", "notes", column: "replaced_by_id"
  add_foreign_key "notes", "notes", column: "replacing_id"
  add_foreign_key "notes", "team_members"
  add_foreign_key "notes", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "survey_answers", "survey_questions"
  add_foreign_key "survey_answers", "survey_responses"
  add_foreign_key "survey_comment_sections", "survey_sections"
  add_foreign_key "survey_comments", "survey_comment_sections"
  add_foreign_key "survey_comments", "survey_responses"
  add_foreign_key "survey_questions", "survey_sections"
  add_foreign_key "survey_responses", "surveys"
  add_foreign_key "survey_responses", "users"
  add_foreign_key "survey_sections", "surveys"
  add_foreign_key "surveys", "team_members"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_pins", "team_members"
  add_foreign_key "user_pins", "users"
  add_foreign_key "user_profile_view_logs", "team_members"
  add_foreign_key "user_profile_view_logs", "users"
  add_foreign_key "wba_scores", "wellbeing_assessments"
  add_foreign_key "wba_scores", "wellbeing_metrics"
  add_foreign_key "wellbeing_assessments", "team_members"
  add_foreign_key "wellbeing_assessments", "users"
  add_foreign_key "wellbeing_metrics", "team_members"
  add_foreign_key "wellbeing_services", "team_members"
end
