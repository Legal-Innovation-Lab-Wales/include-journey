# db/migrate/20210528104768_add_user_cache_columns.rb
class AddUserCacheColumns < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.date :last_session_at
      t.integer :sessions_streak, null: false, default: 0
      t.integer :sessions_count, null: false, default: 0
      t.integer :sessions_this_month_count, null: false, default: 0
      t.integer :wellbeing_assessments_count, null: false, default: 0
      t.integer :wellbeing_assessments_this_month_count, null: false, default: 0
      t.integer :journal_entries_count, null: false, default: 0
      t.integer :journal_entries_this_month_count, null: false, default: 0
      t.integer :goals_achieved_count, null: false, default: 0
      t.integer :goals_achieved_this_month_count, null: false, default: 0
    end
  end
end
