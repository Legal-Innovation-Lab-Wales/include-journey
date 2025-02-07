# frozen_string_literal: true

# app/models/survey_answer.rb
class SurveyAnswer < ApplicationRecord
  belongs_to :survey_question
  belongs_to :survey_response

  after_create :add_to_question_cache
  before_update :remove_from_question_cache
  after_update :add_to_question_cache
  before_destroy :remove_from_question_cache

  # TODO: Rails 6 does not support numericality in: range
  #validates :answer, numericality: {only_integer: true, in: 0..5}
  validates :answer, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
  validate :check_answer_in_range

  private

  def add_to_question_cache
    return if answer.blank?

    k = "answer#{answer}"
    survey_question.update!(
      total: survey_question.total + 1,
      k => survey_question[k] + 1,
    )
  end

  def remove_from_question_cache
    return if answer_was.blank?

    k = "answer#{answer_was}"
    survey_question.update!(
      total: survey_question.total - 1,
      k => survey_question[k] - 1,
    )
  end

  def check_answer_in_range
    return if survey_question.nil? || answer.nil?

    len = survey_question.survey_section.answer_labels_array.length
    if answer < 0 || answer >= len
      errors.add(:answer, 'must be in range')
    end
  end
end
