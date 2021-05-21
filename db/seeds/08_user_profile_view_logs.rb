if UserProfileViewLog.count.zero?
  # Create a view log of every user for every team member
  User.all.each do |user|
    TeamMember.all.each do |team_member|
      created_at = rand(1..100).days.ago
      view_count = rand(1..10)
      updated_at = view_count == 1 ? created_at : Faker::Time.between(from: created_at, to: DateTime.now)

      UserProfileViewLog.create!(
        team_member: team_member,
        user: user,
        created_at: created_at,
        updated_at: updated_at,
        view_count: view_count
      )
    end
  end

  puts "User Profile View Logs\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end