# frozen_string_literal: true

# app/models/survey.rb
class Survey < ApplicationRecord
  belongs_to :team_member
  has_many :survey_sections, dependent: :destroy
  has_many :survey_responses
  has_many :survey_questions, through: :survey_sections
  has_many :survey_comment_sections, through: :survey_sections

  scope :available, -> { where('start_date <= :now and end_date >= :now and active = true', now: Time.current) }

  validates :name, :start_date, :end_date, presence: true
  validates :name, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :start_date, :end_date, format: {
    with: Rails.application.config.regex_datetime,
    message: Rails.application.config.datetime_error,
  }

  def start
    start_date.strftime('%d/%m/%Y')
  end

  def end
    end_date.strftime('%d/%m/%Y')
  end

  def next_section
    return 1 if survey_sections.none?

    survey_sections.order(order: :desc).first.order + 1
  end
end
