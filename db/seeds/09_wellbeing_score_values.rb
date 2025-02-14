# frozen_string_literal: true

if WellbeingScoreValue.none?
  print "#{pretty_print_name('Score Values')}\tStart: #{pretty_print(Time.current - @start_time)}"
  WellbeingScoreValue.create!(
    name: 'Absymal',
    color: '#E04444',
  )
  WellbeingScoreValue.create!(
    name: 'Dreadful',
    color: '#e66043',
  )
  WellbeingScoreValue.create!(
    name: 'Rubbish',
    color: '#eb7945',
  )
  WellbeingScoreValue.create!(
    name: 'Bad',
    color: '#ee904b',
  )
  WellbeingScoreValue.create!(
    name: 'Mediocre',
    color: '#F0A656',
  )
  WellbeingScoreValue.create!(
    name: 'Fine',
    color: '#DFC54C',
  )
  WellbeingScoreValue.create!(
    name: 'Good',
    color: '#c1c041',
  )
  WellbeingScoreValue.create!(
    name: 'Great',
    color: '#a2ba3a',
  )
  WellbeingScoreValue.create!(
    name: 'Superb',
    color: '#82b438',
  )
  WellbeingScoreValue.create!(
    name: 'Perfect',
    color: '#5DAD3A',
  )

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
