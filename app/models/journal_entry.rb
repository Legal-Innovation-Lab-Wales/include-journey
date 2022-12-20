# app/models/journal_entry.rb
class JournalEntry < PermissionRecord
  belongs_to :user
  validates_format_of :entry, with: /\A[a-zA-Z0-9_,.@ ]*\z/, on: :create, message: "Invalid: Please only use the characters A-Z,0-9 & (. , @)"

  has_many :journal_entry_permissions, foreign_key: :journal_entry_id, dependent: :delete_all
  has_many :journal_entry_view_logs, foreign_key: :journal_entry_id, dependent: :delete_all

  after_create :update_cache

  scope :created_in_last_week, -> { where('journal_entries.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('journal_entries.created_at >= ?', 1.month.ago) }

  def permissions
    journal_entry_permissions
  end

  def to_csv
    [id, created] + user.to_csv + [feeling, entry]
  end

  def json
    {
      'ID': id,
      'Date': created,
      'Feeling': feeling,
      'Entry': entry
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
  end

  private

  def update_cache
    user.update!(last_journal_entry_at: Date.today,
                 journal_entries_count: user.journal_entries_count + 1,
                 journal_entries_this_month_count: user.journal_entries_this_month_count + 1)
  end
end
