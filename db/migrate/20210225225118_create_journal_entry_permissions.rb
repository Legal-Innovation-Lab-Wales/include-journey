# db/migrate/20210225225118_create_journal_entry_permissions.rb
class CreateJournalEntryPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :journal_entry_permissions do |t|
      t.belongs_to :journal_entry, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
