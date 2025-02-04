# frozen_string_literal: true

if UserTag.count.zero?
  print "#{pretty_print_name('User Tags')}\tStart: #{pretty_print(Time.now - @start_time)}"
  User.all.each do |user|
    if user.id.even?
      half = (Tag.count / 2).floor
      first_tag = Tag.find(rand(1...half))
      second_tag = Tag.find(rand(half..Tag.count))

      UserTag.create!(
        tag: first_tag,
        user: user,
        team_member_id: rand(1..TeamMember.count),
        created_at: first_tag.created_at + rand(1..7).days,
      )
      UserTag.create!(
        tag: second_tag,
        user: user,
        team_member_id: rand(1..TeamMember.count),
        created_at: second_tag.created_at + rand(1..7).days,
      )
    else
      tag = Tag.find(rand(1..Tag.count))
      UserTag.create!(
        tag: tag,
        user: user,
        team_member_id: rand(1..TeamMember.count),
        created_at: tag.created_at + rand(1..7).days,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
