if CrisisType.count.zero?
  CrisisType.create!(category: 'Self Harm', team_member_id: 1)
  CrisisType.create!(category: 'Harming Others', team_member_id: 1)
  CrisisType.create!(category: 'Suicide', team_member_id: 1)
  CrisisType.create!(category: 'Overdose', team_member_id: 1)
  CrisisType.create!(category: 'Domestic Violence', team_member_id: 1)

  puts "Crisis Types\t\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
