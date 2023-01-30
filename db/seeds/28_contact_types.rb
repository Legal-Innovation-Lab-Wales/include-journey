if ContactType.count.zero?
  print "#{pretty_print_name('Contact Types')}\tStart: #{pretty_print(Time.now - @start_time)}"
  ContactType.create!(name: 'Meeting')
  ContactType.create!(name: 'Phone Call')
  ContactType.create!(name: 'Other')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end