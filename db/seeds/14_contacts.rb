if Contact.count.zero?
  print "Contacts\t\tStart: #{Time.now - @start_time}"
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

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
