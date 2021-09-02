# app/models/user_achievement.rb
class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  validates_presence_of :user_id, :achievement_id, :progress
end
