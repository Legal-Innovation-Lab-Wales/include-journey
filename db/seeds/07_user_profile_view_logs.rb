# frozen_string_literal: true

if UserProfileViewLog.none?
  print "#{pretty_print_name('User Profile View Logs')}\tStart: #{pretty_print(Time.current - @start_time)}"
  # Create a view log of every user for every team member
  User.find_each do |user|
    TeamMember.find_each do |team_member|
      created_at = rand(1..100).days.ago
      view_count = rand(1..10)
      updated_at = view_count == 1 ? created_at : Faker::Time.between(from: created_at, to: Time.current)

      UserProfileViewLog.create!(
        team_member: team_member,
        user: user,
        created_at: created_at,
        updated_at: updated_at,
        view_count: view_count,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
