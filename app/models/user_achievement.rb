# frozen_string_literal: true

# app/models/user_achievement.rb
class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_update :update_cache

  validates :user_id, :achievement_id, presence: true

  private

  def update_cache
    if gold_achieved_changed?
      user.update!(gold_achievements_count: user.gold_achievements_count + 1)
    elsif silver_achieved_changed?
      user.update!(silver_achievements_count: user.silver_achievements_count + 1)
    else
      user.update!(bronze_achievements_count: user.bronze_achievements_count + 1)
    end
  end
end
