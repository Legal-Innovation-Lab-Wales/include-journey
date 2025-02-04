# frozen_string_literal: true

# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :team_member
  belongs_to :note

  validates :user_id, :team_member_id, :note_id, presence: true

  def read?
    self[:read]
  end
end
