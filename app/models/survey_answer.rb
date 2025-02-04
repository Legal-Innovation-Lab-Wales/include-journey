# frozen_string_literal: true

# app/models/survey_answer.rb
class SurveyAnswer < ApplicationRecord
  belongs_to :survey_question
  belongs_to :survey_response

  after_create :increment_total
  before_update :decrement_answer_count
  after_update :increment_answer_count
  before_destroy :decrement_answer_count, :decrement_total

  validates :survey_question_id, :survey_response_id, presence: true
  validates :answer, numericality: {only_integer: true, in: 0..5}

  def increment_total
    survey_question.update!(total: survey_question.total + 1)
  end

  def decrement_total
    survey_question.update!(total: survey_question.total - 1)
  end

  def increment_answer_count
    survey_question.update!("answer#{answer}" => survey_question["answer#{answer}"] + 1)
  end

  def decrement_answer_count
    return if answer_was.blank?

    survey_question.update!("answer#{answer_was}" => survey_question["answer#{answer_was}"] - 1)
  end
end
