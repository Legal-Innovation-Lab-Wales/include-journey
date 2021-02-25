class WbaTeamMemberScore < ApplicationRecord
  belongs_to :wba_team_member
  belongs_to :wellbeing_metric
end
