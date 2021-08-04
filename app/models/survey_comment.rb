# app/models/survey_comment.rb
class SurveyUserComment < ApplicationRecord
  belongs_to :survey_comment_section
  belongs_to :survey_response

  validates_presence_of :survey_comment_section_id, :survey_response_id, :text
end
