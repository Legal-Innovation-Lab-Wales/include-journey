# app/models/survey_comment.rb
class SurveyComment < ApplicationRecord
  belongs_to :survey_comment_section
  belongs_to :survey_response
  has_one :user, through: :survey_response

  after_create :increment_total
  before_destroy :decrement_total

  validates_presence_of :survey_comment_section_id, :survey_response_id

  def increment_total
    survey_comment_section.update!(total: survey_comment_section.total + 1)
  end

  def decrement_total
    survey_comment_section.update!(total: survey_comment_section.total - 1)
  end
end
