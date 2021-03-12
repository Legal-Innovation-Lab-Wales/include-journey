# db/migrate/20210225225117_create_journal_entries.rb
class CreateJournalEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :journal_entries do |t|
      t.text :entry
      t.text :feeling
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
