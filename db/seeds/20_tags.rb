if Tag.count.zero?
  Tag.create!(tag: 'DV Victim', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: 'DV Perpetrator', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: 'Sexual Violence', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: 'Physical Violence', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: 'Addiction', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: 'Mental Health', team_member_id: rand(1..TeamMember.count))
  Tag.create!(tag: "Women's Pathfinder Project", team_member_id: rand(1..TeamMember.count))

  puts "Tags\t\t\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
