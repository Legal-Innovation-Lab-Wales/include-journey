if WellbeingMetric.count.zero?
  print "#{pretty_print_name('Wellbeing Metrics')}\tStart: #{pretty_print(Time.now - @start_time)}"
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Employment/Education/Training',
    category: 'Personal',
    icon: 'user-tie',
    colour: '#FF3333E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Mental Health',
    category: 'Health',
    icon: 'brain',
    colour: '#FF9933E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Emotional Health',
    category: 'Health',
    icon: 'heartbeat',
    colour: '#FFFF33E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Physical Health',
    category: 'Health',
    icon: 'running',
    colour: '#99FF33E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Behaviour',
    category: 'Personal',
    icon: 'people-carry',
    colour: '#33FF33E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Addiction',
    category: 'Health',
    icon: 'capsules',
    colour: '#33FF99E6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Relationships',
    category: 'Personal',
    icon: 'people-arrows',
    colour: '#33FFFFE6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Sense of Community',
    category: 'Personal',
    icon: 'users',
    colour: '#3399FFE6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Housing',
    category: 'Environment',
    icon: 'home',
    colour: '#3333FFE6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Benefits / Money',
    category: 'Environment',
    icon: 'wallet',
    colour: '#9933FFE6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Food',
    category: 'Environment',
    icon: 'pizza-slice',
    colour: '#FF33FFE6',
  )
  WellbeingMetric.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Leisure',
    category: 'Personal',
    icon: 'gamepad',
    colour: '#FF3399E6',
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
