# app/models/goal.rb
class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :goal_type

  scope :short_term, -> { where(short_term: true) }
  scope :long_term, -> { where(short_term: false) }
  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  validates_presence_of :user_id, :goal, :goal_type

  def achieved?
    achieved_on.present?
  end

  def achieved
    achieved_on.strftime('%d/%m/%Y %I:%M %p')
  end
end
