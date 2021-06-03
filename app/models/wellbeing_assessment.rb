# app/models/wba_self.rb
class WellbeingAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  has_many :wba_scores, foreign_key: :wellbeing_assessment_id, dependent: :delete_all

  def today?
    created_at.today?
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
