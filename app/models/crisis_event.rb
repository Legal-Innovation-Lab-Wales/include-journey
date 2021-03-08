class CrisisEvent < ApplicationRecord
  belongs_to :user
  belongs_to :crisis_type
  belongs_to :closed_by, class_name: 'TeamMember', optional: true
  # belongs_to :closed_by, class_name: 'TeamMember', foreign_key: 'closed_by' Original line
  has_many :crisis_notes, foreign_key: :crisis_event_id
end
