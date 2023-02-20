# app/models/diary_entry_view_log.rb
class JournalEntryViewLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :diary_entry
  has_one :user, through: :diary_entry

  scope :viewed_in_last_week, -> { where('diary_entry_view_logs.updated_at >= ?', 1.week.ago) }
  scope :viewed_in_last_month, -> { where('diary_entry_view_logs.updated_at >= ?', 1.month.ago) }

  validates_presence_of :team_member_id, :diary_entry_id

  def increment_view_count
    self.view_count += 1
  end
end
