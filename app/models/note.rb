# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :replaced_by, class_name: 'Note', optional: true, foreign_key: 'replaced_by_id'
  belongs_to :replacing, class_name: 'Note', optional: true, foreign_key: 'replacing_id'

  validates_presence_of :team_member_id, :user_id, :content
end
