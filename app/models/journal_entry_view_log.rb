# app/models/journal_entry_view_log.rb
class JournalEntryViewLog < ApplicationRecord
  after_initialize :increment_view_count

  belongs_to :team_member
  belongs_to :journal_entry

  has_one :user, through: :journal_entry

  validates_presence_of :team_member_id, :journal_entry_id

  def increment_view_count
    self.view_count += 1
  end
end
