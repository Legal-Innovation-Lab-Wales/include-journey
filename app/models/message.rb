# frozen_string_literal: true

# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :team_member
  belongs_to :note

  def read?
    self[:read]
  end
end
