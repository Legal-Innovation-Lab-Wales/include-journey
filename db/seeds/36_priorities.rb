if Priority.count.zero?
  print "#{pretty_print_name('Priorities')}\tStart: #{pretty_print(Time.now - @start_time)}"

  Priority.create!(name: 'Low')
  Priority.create!(name: 'Medium')
  Priority.create!(name: 'High')

  User.all.each do |user|
    user.priority = Priority.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
