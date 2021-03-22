# app/models/journal_entry_view_log.rb
class JournalEntryViewLog < ApplicationRecord
  belongs_to :journal_entry
  belongs_to :team_member

  has_one :user, through: :journal_entry
end
