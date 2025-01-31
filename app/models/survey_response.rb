# app/models/survey_response.rb
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :survey_answers, dependent: :destroy
  has_many :survey_comments, dependent: :destroy

  validates :survey_id, :user_id, presence: true

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
    return unless survey_answers.present?

    survey_answer = survey_answers.find_by(survey_question: question)

    return unless survey_answer.present?

    survey_answer.answer == answer
  end

  def comment(comment_section)
    return '' unless survey_comments.present?

    comment = survey_comments.find_by(survey_comment_section: comment_section)

    comment.present? ? comment.text : ''
  end
end
