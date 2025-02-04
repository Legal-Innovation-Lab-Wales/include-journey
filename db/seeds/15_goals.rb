# frozen_string_literal: true

if Goal.count.zero?
  print "#{pretty_print_name('Goals')}\tStart: #{pretty_print(Time.now - @start_time)}"
  User.all.each do |user|
    Config::GOALS_FOR_EACH_USER.times do |index|
      Goal.create!(
        user: user,
        goal: Faker::Hipster.sentences(number: 1)[0],
        goal_type: GoalType.find((index % 3) + 1),
        short_term: index.even?,
        achieved_on: index < 4 ? Time.now : nil,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
