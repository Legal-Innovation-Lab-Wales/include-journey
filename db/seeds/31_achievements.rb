if Achievement.count.zero?
  print "#{pretty_print_name('Session')}\tStart: #{pretty_print(Time.now - @start_time)}"

  # All time achievements
  Achievement.create!(
    name: 'Familiar Face',
    description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
    resource: 'session',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500
  )

  Achievement.create!(
    name: 'Wellbeing Warrior',
    description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
    resource: 'wellbeing_assessment',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500
  )

  Achievement.create!(
    name: 'Journal Journeyman',
    description: 'This achievement demonstrates your commitment to keeping a regular journal.',
    resource: 'journal_entry',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500
  )

  Achievement.create!(
    name: 'Goal Getter',
    description: 'This achievement demonstrates your commitment to reaching your goals.',
    resource: 'goal',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
