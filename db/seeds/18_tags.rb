# frozen_string_literal: true

if Tag.none?
  print "#{pretty_print_name('Tags')}\tStart: #{pretty_print(Time.current - @start_time)}"
  Tag.create!(tag: 'DV Victim', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: 'DV Perpetrator', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: 'Sexual Violence', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: 'Physical Violence', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: 'Addiction', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: 'Mental Health', team_member_id: rand(1..TeamMember.count), created_at: rand(1..30).days.ago)
  Tag.create!(tag: "Women's Pathfinder Project", team_member_id: rand(1..TeamMember.count),
    created_at: rand(1..30).days.ago,)

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
