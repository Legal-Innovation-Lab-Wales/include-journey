if Achievement.count.zero?
  print "#{pretty_print_name('Session')}\tStart: #{pretty_print(Time.now - @start_time)}"

  # All time achievements
  Achievement.create!(
    name: 'Familiar Face',
    description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
    resource: 'sessions',
    count: 1000,
    intervals: { 'bronze': 100, 'silver': 250, 'gold': 500 }
  )

  Achievement.create!(
    name: 'Wellbeing Warrior',
    description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
    resource: 'wellbeing_assessments',
    count: 1000,
    intervals: { 'bronze': 100, 'silver': 250, 'gold': 500 }
  )

  Achievement.create!(
    name: 'William Shakespeare',
    description: 'This achievement demonstrates your commitment to keeping a regular journal.',
    resource: 'journal_entries',
    count: 1000,
    intervals: { 'bronze': 100, 'silver': 250, 'gold': 500 }
  )

  Achievement.create!(
    name: 'Goal Getter',
    description: 'This achievement demonstrates your commitment to reaching your goals.',
    resource: 'goals_achieved',
    count: 1000,
    intervals: { 'bronze': 100, 'silver': 250, 'gold': 500 }
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
