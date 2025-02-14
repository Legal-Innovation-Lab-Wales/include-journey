# frozen_string_literal: true

if EmergencyContact.none?
  print "#{pretty_print_name('Emergency Contacts')}\tStart: #{pretty_print(Time.current - @start_time)}"

  User.find_each do |user|
    emergency_contact = EmergencyContact.new(
      name: Faker::Name.name_with_middle,
      relationship: Faker::Relationship.familial,
      number: Faker::Number.leading_zero_number(digits: 11),
      user: user,
    )
    emergency_contact.save!
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
