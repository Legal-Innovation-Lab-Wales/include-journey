# frozen_string_literal: true

# app/models/journal_entry_view_log.rb
class JournalEntryViewLog < ApplicationRecord
  belongs_to :journal_entry
  belongs_to :team_member
end
