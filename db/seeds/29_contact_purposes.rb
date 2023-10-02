if ContactPurpose.count.zero?
  print "#{pretty_print_name('Contact Purposes')}\tStart: #{pretty_print(Time.now - @start_time)}"
  ContactPurpose.create!(name: 'One-to-one')
  ContactPurpose.create!(name: 'Benefits')
  ContactPurpose.create!(name: 'Computer use')
  ContactPurpose.create!(name: 'Education')
  ContactPurpose.create!(name: 'Emotional support')
  ContactPurpose.create!(name: 'Employment')
  ContactPurpose.create!(name: 'Food')
  ContactPurpose.create!(name: 'Food bank')
  ContactPurpose.create!(name: 'Housing')
  ContactPurpose.create!(name: 'Mental health')
  ContactPurpose.create!(name: 'Money')
  ContactPurpose.create!(name: 'Phone use')
  ContactPurpose.create!(name: 'Physical health')
  ContactPurpose.create!(name: 'Training')
  ContactPurpose.create!(name: 'Utilities')
  ContactPurpose.create!(name: "Women's day")
  ContactPurpose.create!(name: 'Interpersonal Violence Support')
  ContactPurpose.create!(name: 'Social Connect (Combating Isolation)')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end