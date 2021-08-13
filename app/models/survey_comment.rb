# app/models/survey_comment.rb
class SurveyComment < ApplicationRecord
  belongs_to :survey_comment_section
  belongs_to :survey_response
  has_one :user, through: :survey_response

  validates_presence_of :survey_comment_section_id, :survey_response_id
end
