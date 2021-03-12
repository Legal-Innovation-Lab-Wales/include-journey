# app/models/wba_self_view_log.rb
class WbaSelfViewLog < ApplicationRecord
  belongs_to :wba_self
  belongs_to :team_member

  has_one :user, through: :wba_self
end
