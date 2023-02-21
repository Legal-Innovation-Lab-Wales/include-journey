class GoalPermission < ApplicationRecord
  belongs_to :user
  belongs_to :team_member
end
