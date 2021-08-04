# app/models/survey_comment.rb
class SurveyUserComment < ApplicationRecord
  belongs_to :survey_comment_section
  belongs_to :user

  validates_presence_of :survey_comment_section_id, :user_id, :text
end
