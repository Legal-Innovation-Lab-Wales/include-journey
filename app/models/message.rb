# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :team_member

  validates_presence_of :user_id, :team_member_id, :note_id
end
