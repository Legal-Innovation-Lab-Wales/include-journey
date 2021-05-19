if UserTag.count.zero?
  User.all.each do |user|
    if user.id.even?
      first_tag = rand(1..(Tag.count / 2).floor)
      second_tag = rand((Tag.count / 2).floor..Tag.count)

      UserTag.create!(tag_id: first_tag, user: user, team_member_id: rand(1..TeamMember.count))
      UserTag.create!(tag_id: second_tag, user: user, team_member_id: rand(1..TeamMember.count))
    else
      UserTag.create!(tag_id: rand(1..Tag.count), user: user, team_member_id: rand(1..TeamMember.count))
    end
  end

  puts "User Tags\t\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
