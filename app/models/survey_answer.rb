# app/models/survey_answer.rb
class SurveyAnswer < ApplicationRecord
  belongs_to :survey_question
  belongs_to :user

  validates_presence_of :survey_question_id, :user_id, :answer
end
