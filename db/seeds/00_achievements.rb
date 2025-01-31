if Achievement.count.zero?
  print "#{pretty_print_name('Achievements')}\tStart: #{pretty_print(Time.now - @start_time)}"

  # All time achievements
  Achievement.create!(
    name: 'Familiar Face',
    description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
    entities: 'sessions',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500,
  )

  Achievement.create!(
    name: 'Wellbeing Warrior',
    description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
    entities: 'wellbeing_assessments',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500,
  )

  Achievement.create!(
    name: 'Diary Journeyman',
    description: 'This achievement demonstrates your commitment to keeping a regular diary.',
    entities: 'diary_entries',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500,
  )

  Achievement.create!(
    name: 'Goal Getter',
    description: 'This achievement demonstrates your commitment to reaching your goals.',
    entities: 'goals_achieved',
    bronze_count: 100,
    silver_count: 250,
    gold_count: 500,
  )

  # Monthly Achievements | see: scheduler.rake
  start_date = Date.today.at_beginning_of_month
  end_date = Date.today.at_end_of_month
  count = end_date.day
  month = Date.today.strftime('%B %Y')

  Achievement.create!(
    name: "Familiar Face #{month}",
    description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
    entities: 'sessions',
    starts_at: start_date,
    ends_at: end_date,
    bronze_count: 10,
    silver_count: 20,
    gold_count: count,
  )

  Achievement.create!(
    name: "Wellbeing Warrior #{month}",
    description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
    entities: 'wellbeing_assessments',
    starts_at: start_date,
    ends_at: end_date,
    bronze_count: 10,
    silver_count: 20,
    gold_count: count,
  )

  Achievement.create!(
    name: "Diary Journeyman #{month}",
    description: 'This achievement demonstrates your commitment to keeping a regular diary.',
    entities: 'diary_entries',
    starts_at: start_date,
    ends_at: end_date,
    bronze_count: 10,
    silver_count: 20,
    gold_count: count,
  )

  Achievement.create!(
    name: "Goal Getter #{month}",
    description: 'This achievement demonstrates your commitment to reaching your goals.',
    entities: 'goals_achieved',
    starts_at: start_date,
    ends_at: end_date,
    bronze_count: 10,
    silver_count: 20,
    gold_count: count,
  )

  puts "\tDuration: #{pretty_print(Time.now - @start_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
