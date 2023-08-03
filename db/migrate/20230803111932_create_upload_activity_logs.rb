class CreateUploadActivityLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_activity_logs do |t|
      t.string :activity_type
      t.datetime :activity_time
      t.integer :create_count, default: 0
      t.integer :view_count, default: 0
      t.integer :modify_count, default: 0
      t.integer :download_count, default: 0
      t.integer :approve_count, default: 0
      t.integer :reject_count, default: 0
      t.references :team_members, null: false, foreign_key: true
      t.references :uploads, null: false, foreign_key: true

      t.timestamps
    end
  end
end
