# app/helpers/achievements_helper.rb
module AchievementsHelper
  def progress(user, achievement, monthly)
    (count(user, achievement, monthly).to_f / achievement.gold_count) * 100
  end

  def count(user, achievement, monthly)
    user["#{achievement.entities}_#{monthly ? 'this_month_' : ''}count"]
  end

  def medal(medal_count, achievement)
    "#{(medal_count.to_f / achievement.gold_count) * 100}%"
  end
end
