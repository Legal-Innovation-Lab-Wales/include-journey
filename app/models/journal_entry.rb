# app/models/journal_entry.rb
class JournalEntry < PermissionRecord
  belongs_to :user

  has_many :journal_entry_permissions, foreign_key: :journal_entry_id, dependent: :delete_all
  has_many :journal_entry_view_logs, foreign_key: :journal_entry_id, dependent: :delete_all

  scope :created_in_last_week, -> { where('journal_entries.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('journal_entries.created_at >= ?', 1.month.ago) }

  def permissions
    journal_entry_permissions
  end
end
