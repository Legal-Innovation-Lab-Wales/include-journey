# app/models/survey_comment.rb
class SurveyComment < ApplicationRecord
  belongs_to :survey_comment_section
  belongs_to :survey_response
  has_one :user, through: :survey_response

  after_create :increment_total
  before_destroy :decrement_total

  validates :survey_comment_section_id, :survey_response_id, presence: true
  validates :text, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }

  def increment_total
    survey_comment_section.update!(total: survey_comment_section.total + 1)
  end

  def decrement_total
    survey_comment_section.update!(total: survey_comment_section.total - 1)
  end
end
