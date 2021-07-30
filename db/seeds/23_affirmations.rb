if Affirmation.count.zero?
  print "#{pretty_print_name('User Tags')}\tStart: #{pretty_print(Time.now - @start_time)}"
  30.times.each do |index|
    text = if index < 10
             Faker::Quotes::Shakespeare.hamlet_quote
           elsif index < 20
             Faker::Quotes::Shakespeare.romeo_and_juliet_quote
           else
             Faker::Quotes::Shakespeare.king_richard_iii_quote
           end

    Affirmation.create!(
      text: text,
      scheduled_date: Date.today + index.days,
      team_member: TeamMember.find(rand(1..TeamMember.count))
    )
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
