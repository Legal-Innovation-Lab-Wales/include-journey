if WellbeingScoreValue.count.zero?
  print "Score Values\tStart: #{Time.now - @start_time}"
  WellbeingScoreValue.create!(
    value: 1,
    name: 'absymal',
    color: '#E04444'
    )
  WellbeingScoreValue.create!(
    value: 2,
    name: 'dreadful',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 3,
    name: 'rubbish',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 4,
    name: 'bad',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 5,
    name: 'mediocre',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 6,
    name: 'fine',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 7,
    name: 'good',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 8,
    name: 'great',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 9,
    name: 'superb',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    value: 10,
    name: 'perfect',
    color: '#E04444'
  )

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
