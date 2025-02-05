# frozen_string_literal: true

if Session.count.zero?
  print "#{pretty_print_name('Sessions')}\tStart: #{pretty_print(Time.current - @start_time)}"

  User.find_each do |user|
    30.times.reverse_each do |i|
      Session.create!(user: user, session_at: Date.current - i.days) unless rand(1..5) == 1
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
