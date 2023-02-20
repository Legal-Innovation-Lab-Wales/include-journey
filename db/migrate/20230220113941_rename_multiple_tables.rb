# db/migrate/20230220113941_rename_multiple_tables.rb
class RenameMultipleTables < ActiveRecord::Migration[6.1]
  def change
    # For change in journal entry view logs
    rename_table :journal_entry_view_logs, :diary_view_logs

    # For change in journal entry permissions
    rename_table :journal_entry_permissions, :diary_permissions

    # For change in journal entries
    rename_table :journal_entries, :diaries
  end
end
