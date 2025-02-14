# frozen_string_literal: true

if Goal.none?
  print "#{pretty_print_name('Goals')}\tStart: #{pretty_print(Time.current - @start_time)}"
  User.find_each do |user|
    Config::GOALS_FOR_EACH_USER.times do |index|
      Goal.create!(
        user: user,
        goal: Faker::Hipster.sentences(number: 1)[0],
        goal_type: GoalType.find((index % 3) + 1),
        short_term: index.even?,
        achieved_on: index < 4 ? Time.current : nil,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
