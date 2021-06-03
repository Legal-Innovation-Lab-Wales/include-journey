if WellbeingScoreValue.count.zero?
  print "Score Values\t\tStart: #{pretty_print(Time.now - @start_time)}"
  WellbeingScoreValue.create!(
    name: 'Absymal',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Dreadful',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Rubbish',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Bad',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Mediocre',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Fine',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Good',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Great',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Superb',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'Perfect',
    color: '#E04444'
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
