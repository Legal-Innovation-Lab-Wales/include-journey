# app/helpers/achievements_helper.rb
module AchievementsHelper

  def progress(user, achievement, month)
    (count(user, achievement, month).to_f / achievement.gold_count) * 100
  end

  def count(user, achievement, month)
    user["#{achievement.entities}_#{month ? 'this_month_' : ''}count"]
  end

  def medal(medal_count, achievement)
    "#{(medal_count.to_f / achievement.gold_count) * 100}%"
  end

  def achieved(user, achievement, month, count)
    count(user, achievement, month) >= count
  end
end
