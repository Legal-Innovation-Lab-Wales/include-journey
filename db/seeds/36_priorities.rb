# frozen_string_literal: true

if Priority.none?
  print "#{pretty_print_name('Priorities')}\tStart: #{pretty_print(Time.current - @start_time)}"

  Priority.create!(name: 'Low')
  Priority.create!(name: 'Medium')
  Priority.create!(name: 'High')

  User.find_each do |user|
    user.priority = Priority.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
