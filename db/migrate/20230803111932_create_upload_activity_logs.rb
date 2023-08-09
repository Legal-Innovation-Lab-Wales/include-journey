class CreateUploadActivityLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_activity_logs do |t|
      t.string :activity_type
      t.datetime :activity_time
      t.integer :activity_count, default: 0
      t.bigint :team_member_id, null: false, foreign_key: true
      t.bigint :upload_id, null: false, foreign_key: true
      t.string :user_full_name
      t.string :upload_file_name
      t.datetime :file_created_date

      t.timestamps
    end
  end
end
