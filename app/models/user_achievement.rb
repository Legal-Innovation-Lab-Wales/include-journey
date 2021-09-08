# app/models/user_achievement.rb
class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_update :update_cache

  validates_presence_of :user_id, :achievement_id

  private

  def update_cache
    user.update!(achievements_count: user.achievements_count + 1)
  end
end
