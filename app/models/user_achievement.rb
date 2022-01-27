# app/models/user_achievement.rb
class UserAchievement < ApplicationRecord
  belongs_to :user
  belongs_to :achievement

  before_update :update_cache

  validates_presence_of :user_id, :achievement_id

  private

  # rubocop:disable Metrics/AbcSize
  def update_cache
    if gold_achieved_changed?
      user.update!(gold_achievements_count: user.gold_achievements_count + 1)
    elsif silver_achieved_changed?
      user.update!(silver_achievements_count: user.silver_achievements_count + 1)
    else
      user.update!(bronze_achievements_count: user.bronze_achievements_count + 1)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
