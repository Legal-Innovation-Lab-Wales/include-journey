# db/migrate/20230220113926_rename_multiples_columns_in_multiple_tables.rb
class RenameMultiplesColumnsInMultipleTables < ActiveRecord::Migration[6.1]
  def change
    # For change in users table
    rename_column :users, :last_journal_entry_at, :last_diary_entry_at
    rename_column :users, :journal_entries_count, :diary_entries_count
    rename_column :users, :journal_entries_this_month_count, :diary_entries_this_month_count

    # For change in journal entry view logs table
    rename_column :journal_entry_view_logs, :journal_entry_id, :diary_entry_id

    # For change in journal entry permissions
    rename_column :journal_entry_permissions, :journal_entry_id, :diary_entry_id
  end
end
