# app/models/wba_self_permission.rb
class WbaSelfPermission < ApplicationRecord
  belongs_to :wba_self
  belongs_to :team_member
end
