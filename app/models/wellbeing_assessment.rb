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
    [
      id,
      created,
      user.id,
      user.full_name,
      team_member.present? ? team_member.id : nil,
      team_member.present? ? team_member.full_name : nil
    ] + wba_scores.order(:wellbeing_metric_id).map(&:value)
  end
  # rubocop:enable Metrics/AbcSize
end
