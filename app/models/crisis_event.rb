class CrisisEvent < ApplicationRecord
  belongs_to :user
  belongs_to :crisis_type
  belongs_to :closed_by, class_name: 'TeamMember', foreign_key: 'closed_by'
  has_many :crisis_notes, foreign_key: true
end
