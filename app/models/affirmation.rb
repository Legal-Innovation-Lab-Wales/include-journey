# frozen_string_literal: true

# app/models/affirmation.rb
class Affirmation < ApplicationRecord
  belongs_to :team_member
  validates :text, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :scheduled_date, format: {
    with: Rails.application.config.regex_datetime,
    message: Rails.application.config.datetime_error,
  }

  scope :archived, -> { where(scheduled_date: ...Date.current) }
  scope :upcoming, -> { where(scheduled_date: Date.current..) }

  validates :text, :scheduled_date, :team_member_id, presence: true

  def date
    scheduled_date.strftime('%d/%m/%Y')
  end
end
