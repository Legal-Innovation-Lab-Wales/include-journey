# app/models/user_profile_view_log.rb
class UserProfileViewLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :user

  validates_presence_of :team_member_id, :user_id

  def increment_view_count
    :view
  end
end
