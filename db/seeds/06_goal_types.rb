if GoalType.count.zero?
  GoalType.create!(name: 'Aspiration', emoji: '💪')
  GoalType.create!(name: 'Hope', emoji: '🕊')
  GoalType.create!(name: 'Meaning', emoji: '🙏')

  puts "Goal Types\t\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
