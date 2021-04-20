# app/models/goal.rb
class Goal < ApplicationRecord
  enum aim: { aspiration: 'aspiration', hope: 'hope', meaning: 'meaning' }
  enum length: { short_term: 'short_term', long_term: 'long_term' }

  belongs_to :user

  validates_presence_of :user_id, :goal, :length
end
