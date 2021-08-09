# app/models/survey.rb
class Survey < ApplicationRecord
  belongs_to :team_member
  has_many :survey_sections
  has_many :survey_responses
  has_many :survey_questions, through: :survey_sections

  scope :available, -> { where('start_date <= :now and end_date >= :now and active = true', { now: DateTime.now }) }

  validates_presence_of :name, :start_date, :end_date

  def end
    end_date.strftime('%d/%m/%Y')
  end
end
