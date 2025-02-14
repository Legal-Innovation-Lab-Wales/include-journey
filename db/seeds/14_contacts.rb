# frozen_string_literal: true

if Contact.none?
  print "#{pretty_print_name('Contacts')}\tStart: #{pretty_print(Time.current - @start_time)}"
  User.find_each do |user|
    Config::CONTACTS_FOR_EACH_USER.times do
      name = Faker::Name.name
      Contact.create!(
        user: user,
        name: name,
        number: Faker::Number.leading_zero_number(digits: 11),
        email: Faker::Internet.email(name: name, separators: '-'),
        description: Faker::Job.position,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
