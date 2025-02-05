# frozen_string_literal: true

# app/models/wba_self.rb
class WellbeingAssessment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :team_member, optional: true

  after_create :update_cache

  has_many :wba_scores, dependent: :delete_all

  def today?
    created_at.today?
  end

  def add_to_history(history)
    existing_dataset = history[:datasets].find { |dataset| dataset[:label] == 'Average' }

    if existing_dataset.present?
      existing_dataset[:data] << point
    else
      history[:datasets].push({label: 'Average', data: [point]})
    end
  end

  def point
    {x: created_at, y: average}
  end

  def to_csv
    [id, created] + user.to_csv + (if team_member.present?
      team_member.to_csv
    else
      [nil, nil]
    end) + wba_scores.order(:wellbeing_metric_id).map(&:value)
  end

  def json
    obj = {
      ID: id,
      Date: created,
    }

    obj = obj.merge(user.json.transform_keys { |key| "User #{key}" })
    if team_member.present?
      obj = obj.merge(team_member.json.transform_keys { |key| "Team Member #{key}" })
    end

    obj[:Scores] = wba_scores
      .order(:wellbeing_metric_id)
      .to_h { |score| [score.wellbeing_metric.name, score.value] }

    obj
  end

  private

  def update_cache
    user.update!(
      last_wellbeing_assessment_at: Date.current,
      wellbeing_assessments_count: user.wellbeing_assessments_count + 1,
      wellbeing_assessments_this_month_count: user.wellbeing_assessments_this_month_count + 1,
    )
  end
end
