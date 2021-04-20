# app/models/goal.rb
class Goal < ApplicationRecord
  enum aim: { aspiration: 'aspiration', hope: 'hope', meaning: 'meaning' }
  enum length: { short_term: 'short_term', long_term: 'long_term' }

  belongs_to :user

  scope :short_term, -> { where(length: :short_term) }
  scope :long_term, -> { where(length: :long_term) }

  validates_presence_of :user_id, :goal, :length
end
