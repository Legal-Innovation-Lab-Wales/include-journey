# app/models/survey_comment_section.rb
class SurveyCommentSection < ApplicationRecord
  belongs_to :survey_section
  has_many :survey_comments

  validates_presence_of :survey_section_id, :label, :order
end
