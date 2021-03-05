class WellbeingMetric < ApplicationRecord
  belongs_to :team_member

  has_many :wba_self_scores
  has_many :wba_team_member_scores
end
