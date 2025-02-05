# frozen_string_literal: true

if GoalType.count.zero?
  print "#{pretty_print_name('Goal Types')}\tStart: #{pretty_print(Time.current - @start_time)}"
  GoalType.create!(name: 'Aspiration', emoji: '💪')
  GoalType.create!(name: 'Hope', emoji: '🕊')
  GoalType.create!(name: 'Meaning', emoji: '🙏')

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
