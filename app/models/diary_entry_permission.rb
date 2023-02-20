# app/models/diary_entry_permission.rb
class DiaryEntryPermission < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :team_member
end
