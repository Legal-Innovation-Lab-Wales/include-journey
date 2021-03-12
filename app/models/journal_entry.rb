# app/models/journal_entry.rb
class JournalEntry < PermissionRecord
  belongs_to :user

  has_many :journal_entry_permissions, foreign_key: :journal_entry_id
  has_many :journal_entry_view_logs, foreign_key: :journal_entry_id

  def permissions
    journal_entry_permissions
  end
end
