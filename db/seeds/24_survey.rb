if Survey.count.zero?
  print "#{pretty_print_name('Survey')}\tStart: #{pretty_print(Time.now - @start_time)}"

  Survey.create!(
    name: 'HUB Survey 2021',
    start_date: DateTime.new(2021, 1, 1, 0, 0, 0),
    end_date: DateTime.new(2021, 12, 31, 23, 59, 59),
    active: true,
    team_member_id: rand(1..TeamMember.count)
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
