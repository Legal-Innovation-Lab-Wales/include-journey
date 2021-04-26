# app/models/crisis_note.rb
class CrisisNote < ApplicationRecord
  belongs_to :crisis_event
  belongs_to :team_member
  belongs_to :replaced_by, class_name: 'CrisisNote', optional: true, foreign_key: 'replaced_by_id'
  belongs_to :replacing, class_name: 'CrisisNote', optional: true, foreign_key: 'replacing_id'

  validates_presence_of :crisis_event_id, :team_member_id, :content
end
