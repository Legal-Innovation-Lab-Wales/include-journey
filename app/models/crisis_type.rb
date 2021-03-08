class CrisisType < ApplicationRecord
  belongs_to :team_member

  has_many :crisis_events, foreign_key: :crisis_type_id
end
