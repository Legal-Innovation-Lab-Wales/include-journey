if ContactType.count.zero?
  print "#{pretty_print_name('Contact Types')}\tStart: #{pretty_print(Time.now - @start_time)}"
  ContactType.create!(name: 'Drop in')
  ContactType.create!(name: 'Scheduled 1:1')
  ContactType.create!(name: 'Telephone call')
  ContactType.create!(name: 'Email')
  ContactType.create!(name: 'Other')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end