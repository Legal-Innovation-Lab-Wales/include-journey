if EmergencyContact.count.zero?
  print "#{pretty_print_name('Emergency Contacts')}\tStart: #{pretty_print(Time.now - @start_time)}"

  User.all.each do |user|
    emergency_contact = EmergencyContact.new(name: Faker::Name.name_with_middle,
                                             relationship: Faker::Relationship.familial,
                                             number: Faker::Number.leading_zero_number(digits: 11),
                                             user: user)
    emergency_contact.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
