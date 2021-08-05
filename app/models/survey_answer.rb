# app/models/survey_answer.rb
class SurveyAnswer < ApplicationRecord
  belongs_to :survey_question
  belongs_to :survey_response

  validates_presence_of :survey_question_id, :survey_response_id
end
