if WellbeingScoreValue.count.zero?
  print "Score Values\t\tStart: #{Time.now - @start_time}"
  WellbeingScoreValue.create!(
    name: 'absymal',
    color: '#E04444'
    )
  WellbeingScoreValue.create!(
    name: 'dreadful',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'rubbish',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'bad',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'mediocre',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'fine',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'good',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'great',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'superb',
    color: '#E04444'
  )
  WellbeingScoreValue.create!(
    name: 'perfect',
    color: '#E04444'
  )

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
