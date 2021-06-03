if Appointment.count.zero?
  print "Appointments\t\tStart: #{Time.now - @start_time}"
  User.all.each do |user|
    Config::APPOINTMENTS_FOR_EACH_USER.times do
      app_time = Faker::Time.between(from: DateTime.now, to: DateTime.tomorrow + 20.days)

      Appointment.create!(
        user: user,
        who_with: Faker::FunnyName.name,
        where: Faker::Nation.capital_city,
        what: Faker::Educator.course_name,
        start: app_time,
        end: app_time + rand(10..120).minutes
      )
    end

    Config::PAST_APPOINTMENTS_FOR_EACH_USER.times do
      app_time = Faker::Time.between(from: DateTime.now - 20.days, to: DateTime.yesterday)

      Appointment.create!(
        user: user,
        who_with: Faker::FunnyName.name,
        where: Faker::Nation.capital_city,
        what: Faker::Educator.course_name,
        start: app_time,
        end: app_time + rand(10..120).minutes
      )
    end
  end

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
