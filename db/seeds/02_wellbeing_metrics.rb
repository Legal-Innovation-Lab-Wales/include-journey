if WellbeingMetric.count.zero?
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Employment/Education/Training',
    category: 'Personal',
    icon: 'user-tie'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Mental Health',
    category: 'Health',
    icon: 'brain'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Emotional Health',
    category: 'Health',
    icon: 'heartbeat'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Physical Health',
    category: 'Health',
    icon: 'running'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Behaviour',
    category: 'Personal',
    icon: 'people-carry'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Addiction',
    category: 'Health',
    icon: 'capsules'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Relationships',
    category: 'Personal',
    icon: 'people-arrows'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Sense of Community',
    category: 'Personal',
    icon: 'users'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Housing',
    category: 'Environment',
    icon: 'home'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Benefits / Money',
    category: 'Environment',
    icon: 'wallet'
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Food',
    category: 'Environment',
    icon: 'pizza-slice'
  )

  puts "Wellbeing Metrics\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
