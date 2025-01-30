# app/models/survey_section.rb
class SurveySection < ApplicationRecord
  belongs_to :survey
  has_many :survey_questions, dependent: :destroy
  has_many :survey_comment_sections, dependent: :destroy

  LIKERT_5_ANSWER_LABELS = 'Strongly Disagree; Disagree; Neither Agree Nor Disagree; Agree; Strongly Agree; Not Applicable'
  YES_NO_ANSWER_LABELS = 'Yes; No'

  ANSWER_LABELS_OPTIONS = [
    YES_NO_ANSWER_LABELS,
    LIKERT_5_ANSWER_LABELS,
  ]

  validates_presence_of :survey_id
  validates_format_of :heading, with: Rails.application.config.regex_text_field,
                                message: Rails.application.config.text_field_error

  validate :must_have_two_to_six_answer_labels
  
  def next_question
    return 1 unless survey_questions.present?

    survey_questions.order(order: :desc).first.order + 1
  end

  def next_comment_section
    return 1 unless survey_comment_sections.present?

    survey_comment_sections.order(order: :desc).first.order + 1
  end

  def answer_labels_array
    return [] if answer_labels.nil?

    answer_labels.split(';').map(&:strip)
  end

  private

  def must_have_two_to_six_answer_labels
    return if answer_labels.nil?
    
    labels = answer_labels_array

    if labels.length < 2
      errors.add(:answer_labels, 'Must have at least two answer labels, separated by semicolons')
    elsif labels.length > 6
      errors.add(:answer_labels, 'Cannot have more than six answer labels')
    elsif labels.include? ''
      errors.add(:answer_labels, 'Answer labels separated by semicolons cannot be empty')
    end
  end
end
