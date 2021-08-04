# app/models/survey_section.rb
class SurveySection < ApplicationRecord
  belongs_to :survey
  has_many :survey_questions
  has_many :survey_comment_sections

  validates_presence_of :survey_id
end
