# frozen_string_literal: true

# app/models/survey_response.rb
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :survey_answers, dependent: :destroy
  has_many :survey_comments, dependent: :destroy

  scope :submitted, -> { where.not(submitted_at: nil) }

  def submitted?
    submitted_at.present?
  end

  def submitted
    return 'N/A' unless submitted?

    submitted_at.strftime('%d/%m/%Y %I:%M %p')
  end

  def completion
    answered = survey_answers.count
    total = survey.survey_questions.count

    {
      answered: answered,
      total: total,
      percentage: (answered.to_f / total) * 100,
    }
  end

  def answer?(question, answer)
    return if survey_answers.none?

    survey_answer = survey_answers.find_by(survey_question: question)

    return if survey_answer.blank?

    survey_answer.answer == answer
  end

  def comment(comment_section)
    return '' if survey_comments.none?

    comment = survey_comments.find_by(survey_comment_section: comment_section)

    comment.present? ? comment.text : ''
  end
end
