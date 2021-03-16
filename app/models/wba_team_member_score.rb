# app/models/wba_team_member_score.rb
class WbaTeamMemberScore < ApplicationRecord
  belongs_to :wba_team_member
  belongs_to :wellbeing_metric
end
