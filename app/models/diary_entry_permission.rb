# app/models/diary_entry_permission.rb
class JournalEntryPermission < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :team_member
end
