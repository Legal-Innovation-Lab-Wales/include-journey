# db/migrate/20210505111437_create_user_profile_view_logs.rb
class CreateUserProfileViewLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_profile_view_logs do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.string :view_count

      t.timestamps
    end
  end
end
