if Contact.count.zero?
  print "#{pretty_print_name('Contacts')}\tStart: #{pretty_print(Time.now - @start_time)}"
  User.all.each do |user|
    Config::CONTACTS_FOR_EACH_USER.times do
      name = Faker::Name.name
      Contact.create!(
        user: user,
        name: name,
        number: Faker::Number.leading_zero_number(digits: 11),
        email: Faker::Internet.email(name: name, separators: '-'),
        description: Faker::Job.position
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
