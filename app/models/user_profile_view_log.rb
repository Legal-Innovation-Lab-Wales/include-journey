# app/models/user_profile_view_log.rb
class UserProfileViewLog < ApplicationRecord
  after_initialize :increment_view_count

  belongs_to :team_member
  belongs_to :user

  validates_presence_of :team_member_id, :user_id

  def increment_view_count
    self.view_count += 1
  end
end
