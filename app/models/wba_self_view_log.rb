class WbaSelfViewLog < ApplicationRecord
  belongs_to :wba_self
  belongs_to :team_member

  has_one :user, through: :wba_self
end
