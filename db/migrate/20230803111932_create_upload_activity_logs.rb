class CreateUploadActivityLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_activity_logs do |t|
      t.string :activity_type
      t.datetime :activity_time
      t.references :team_members, null: false, foreign_key: true
      t.references :uploads, null: false, foreign_key: true

      t.timestamps
    end
  end
end
