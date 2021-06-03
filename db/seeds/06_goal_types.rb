if GoalType.count.zero?
  print "Goal Types\t\tStart: #{Time.now - @start_time}"
  GoalType.create!(name: 'Aspiration', emoji: '💪')
  GoalType.create!(name: 'Hope', emoji: '🕊')
  GoalType.create!(name: 'Meaning', emoji: '🙏')

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
