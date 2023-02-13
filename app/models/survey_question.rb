# app/models/survey_question.rb
class SurveyQuestion < ApplicationRecord
  belongs_to :survey_section
  has_many :survey_answers

  validates_presence_of :survey_section_id, :order, :total, :answer0, :answer1, :answer2, :answer3, :answer4, :answer5
  validates_format_of :question, with: Rails.application.config.regex_text_field,
                                 message: Rails.application.config.text_field_error

  scope :invalid, -> { where.not("question <> ''") }
end
