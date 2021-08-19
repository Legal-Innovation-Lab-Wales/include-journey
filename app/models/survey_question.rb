# app/models/survey_question.rb
class SurveyQuestion < ApplicationRecord
  belongs_to :survey_section
  has_many :survey_answers

  validates_presence_of :survey_section_id, :order, :total, :answer0, :answer1, :answer2, :answer3, :answer4, :answer5

  scope :invalid, -> { where.not("question <> ''") }
end
