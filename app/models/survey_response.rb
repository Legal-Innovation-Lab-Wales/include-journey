# app/models/survey_response.rb
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :user

  validates_presence_of :survey_id, :user_id, :submitted
end
