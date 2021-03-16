# app/models/wba_team_member.rb
class WbaTeamMember < ApplicationRecord
  belongs_to :team_member
  belongs_to :user

  has_many :wba_team_member_scores, foreign_key: :wba_team_member_id
end
