if GoalType.count.zero?
  print "Goal Types\t\tStart: #{pretty_print(Time.now - @start_time)}"
  GoalType.create!(name: 'Aspiration', emoji: '💪')
  GoalType.create!(name: 'Hope', emoji: '🕊')
  GoalType.create!(name: 'Meaning', emoji: '🙏')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
