# app/models/goal.rb
class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :goal_type

  scope :short_term, -> { where(short_term: true) }
  scope :long_term, -> { where(short_term: false) }

  validates_presence_of :user_id, :goal, :goal_type
end
