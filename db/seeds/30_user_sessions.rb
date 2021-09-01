if Session.count.zero?
  print "#{pretty_print_name('Session')}\tStart: #{pretty_print(Time.now - @start_time)}"

  User.all.each do |user|
    30.times.reverse_each do |i|
      Session.create!(user: user, session_at: Date.today - i.days) unless rand(1..5) == 1
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
