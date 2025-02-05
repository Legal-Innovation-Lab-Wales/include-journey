# frozen_string_literal: true

if Appointment.count.zero?
  print "#{pretty_print_name('Appointments')}\tStart: #{pretty_print(Time.current - @start_time)}"
  User.find_each do |user|
    Config::APPOINTMENTS_FOR_EACH_USER.times do
      app_time = Faker::Time.between(from: Time.current, to: DateTime.tomorrow + 20.days)

      Appointment.create!(
        user: user,
        who_with: Faker::FunnyName.name,
        where: Faker::Nation.capital_city,
        what: Faker::Educator.course_name,
        start: app_time,
        end: app_time + rand(10..120).minutes,
      )
    end

    Config::PAST_APPOINTMENTS_FOR_EACH_USER.times do
      app_time = Faker::Time.between(from: 20.days.ago, to: DateTime.yesterday)

      Appointment.create!(
        user: user,
        who_with: Faker::FunnyName.name,
        where: Faker::Nation.capital_city,
        what: Faker::Educator.course_name,
        start: app_time,
        end: app_time + rand(10..120).minutes,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
