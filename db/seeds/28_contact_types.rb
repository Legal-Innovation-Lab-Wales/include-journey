# frozen_string_literal: true

if ContactType.count.zero?
  print "#{pretty_print_name('Contact Types')}\tStart: #{pretty_print(Time.now - @start_time)}"
  ContactType.create!(name: 'Drop in', color: '#e66043')
  ContactType.create!(name: 'Scheduled 1:1', color: '#eb7945')
  ContactType.create!(name: 'Telephone call', color: '#ee904b')
  ContactType.create!(name: 'Email', color: '#F0A656')
  ContactType.create!(name: 'Other', color: '#DFC54C')
  ContactType.create!(name: 'Support using the app', color: '9933FFE6')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
