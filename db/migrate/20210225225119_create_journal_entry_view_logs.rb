# db/migrate/20210225225119_create_journal_entry_view_logs.rb
class CreateJournalEntryViewLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :journal_entry_view_logs do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :journal_entry, null: false, foreign_key: true
      t.integer :view_count, default: 0

      t.timestamps
    end
  end
end
