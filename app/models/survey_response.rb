# app/models/survey_response.rb
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :user
  has_many :survey_answers, dependent: :destroy
  has_many :survey_comments, dependent: :destroy

  validates_presence_of :survey_id, :user_id

  def submitted?
    submitted_at.present?
  end
end
