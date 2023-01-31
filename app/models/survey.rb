# app/models/survey.rb
class Survey < ApplicationRecord
  belongs_to :team_member
  has_many :survey_sections, dependent: :destroy
  has_many :survey_responses
  has_many :survey_questions, through: :survey_sections
  has_many :survey_comment_sections, through: :survey_sections

  scope :available, -> { where('start_date <= :now and end_date >= :now and active = true', { now: DateTime.now }) }

  validates_presence_of :name, :start_date, :end_date
  validates_format_of :name, with: Rails.application.config.regex_text_field, on: :create

  def start
    start_date.strftime('%d/%m/%Y')
  end

  def end
    end_date.strftime('%d/%m/%Y')
  end

  def next_section
    return 1 unless survey_sections.present?

    survey_sections.order(order: :desc).first.order + 1
  end
end
