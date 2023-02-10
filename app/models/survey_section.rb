# app/models/survey_section.rb
class SurveySection < ApplicationRecord
  belongs_to :survey
  has_many :survey_questions, dependent: :destroy
  has_many :survey_comment_sections, dependent: :destroy

  validates_presence_of :survey_id
  validates_format_of :heading, with: Rails.application.config.regex_text_field,
                                message: Rails.application.config.text_field_error

  def next_question
    return 1 unless survey_questions.present?

    survey_questions.order(order: :desc).first.order + 1
  end

  def next_comment_section
    return 1 unless survey_comment_sections.present?

    survey_comment_sections.order(order: :desc).first.order + 1
  end
end
