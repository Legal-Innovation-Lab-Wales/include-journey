# app/models/crisis_event.rb
class CrisisEvent < ApplicationRecord
  belongs_to :user
  belongs_to :crisis_type
  belongs_to :closed_by, class_name: 'TeamMember', optional: true
  has_many :crisis_notes, foreign_key: :crisis_event_id

  scope :active, -> { where(closed: false) }
  scope :closed, -> { where(closed: true) }

  def closed_formatted
    closed_at.strftime('%d/%m/%Y %I:%M %p')
  end
end
