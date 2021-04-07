# app/models/wba_self.rb
class WellbeingAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  has_many :wba_scores, foreign_key: :wellbeing_assessment_id

  def add_to_history(history)
    history[:labels].push(created_at.strftime('%d/%m/%Y'))

    wba_scores.includes(:wellbeing_metric).each { |wba_score| wba_score.add_to_history(history) }
  end
end
