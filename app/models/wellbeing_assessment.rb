# app/models/wba_self.rb
class WellbeingAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  has_many :wba_scores, foreign_key: :wellbeing_assessment_id, dependent: :delete_all

  def today?
    created_at.today?
  end

  def add_to_history(history)
    existing_dataset = history[:datasets].find { |dataset| dataset[:label] == 'Average' }

    if existing_dataset.present?
      existing_dataset[:data] << point
    else
      history[:datasets].push({ label: 'Average', data: [point] })
    end
  end

  def point
    { x: created_at, y: average }
  end
end
