if CrisisEvent.count.zero?
  print "#{pretty_print_name('Crisis Events')}\tStart: #{pretty_print(Time.now - @start_time)}"
  Config::CRISIS_EVENTS_COUNT.times do |index|
    crisis_event = CrisisEvent.create!(
      additional_info: Faker::Hipster.sentences(number: 1)[0],
      user_id: rand(1..User.count),
      crisis_type_id: rand(1..CrisisType.count)
    )

    # Half of crisis events are closed
    next unless index.even?

    crisis_event.update!(
      closed: true,
      closed_at: Faker::Date.between(from: DateTime.now - 20.days, to: DateTime.now),
      closed_by_id: rand(1..TeamMember.count)
    )
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
