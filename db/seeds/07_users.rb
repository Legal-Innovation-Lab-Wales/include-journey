if User.count.zero?
  print "#{pretty_print_name('Users')}\tStart: #{pretty_print(Time.now - @start_time)}"
  user_counter = 0

  Config::TOTAL_USER_COUNT.times do
    user_counter += 1

    user = User.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: "IJ-test-user-#{user_counter}@purpleriver.dev",
      mobile_number: Faker::Number.leading_zero_number(digits: 11),
      release_date: rand(1..2).even? ? Faker::Date.between(from: DateTime.now - 20.days, to: DateTime.now) : '',
      terms: true,
      password: 'test1234',
      current_sign_in_at: rand(1..100).days.ago
    )
    user.skip_confirmation!
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
