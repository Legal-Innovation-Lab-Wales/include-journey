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

  # rubocop:disable Metrics/AbcSize
  def to_csv
    [id, created] + user.to_csv + (team_member.present? ? team_member.to_csv : [nil, nil]) + wba_scores.order(:wellbeing_metric_id).map(&:value)
  end

  def json
    {
      'ID': id,
      'Date': created
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
      .merge(team_member.present? ? team_member.json.transform_keys { |key| "Team Member #{key}" } : {})
      .merge({
               'Scores': wba_scores.order(:wellbeing_metric_id).map { |score| { "#{score.wellbeing_metric.name}": score.value } }
             })
  end
  # rubocop:enable Metrics/AbcSize
end
