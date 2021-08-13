# app/models/survey_response.rb
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :survey_answers, dependent: :destroy
  has_many :survey_comments, dependent: :destroy

  validates_presence_of :survey_id, :user_id

  scope :submitted, -> { where('submitted_at is not null') }

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

    { answered: answered, total: total, percentage: ((answered.to_f / total) * 100) }
  end
end
