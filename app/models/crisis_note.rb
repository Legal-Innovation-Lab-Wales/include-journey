class CrisisNote < ApplicationRecord
  belongs_to :crisis_event
  belongs_to :team_member
end
