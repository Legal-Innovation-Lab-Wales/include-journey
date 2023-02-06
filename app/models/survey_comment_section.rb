# app/models/survey_comment_section.rb
class SurveyCommentSection < ApplicationRecord
  belongs_to :survey_section
  has_many :survey_comments

  scope :invalid, -> { where.not("label <> ''") }

  validates_presence_of :survey_section_id, :order, :total
  validates_format_of :label, with: Rails.application.config.regex_text_field,
                              message: Rails.application.config.text_field_error
end
