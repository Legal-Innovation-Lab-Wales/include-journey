# frozen_string_literal: true

# app/models/journal_entry_permission.rb
class JournalEntryPermission < ApplicationRecord
  belongs_to :journal_entry
  belongs_to :team_member
end
