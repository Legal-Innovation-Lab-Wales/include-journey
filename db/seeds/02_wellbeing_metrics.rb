if WellbeingMetric.count.zero?
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Housing', category: 'Environment')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Benefits / Money', category: 'Environment')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Food', category: 'Environment')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Physical Health', category: 'Health')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Mental Health', category: 'Health')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Emotional Health', category: 'Health')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Behaviour', category: 'Personal')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Addiction', category: 'Health')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Relationships', category: 'Personal')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Sense of Community', category: 'Personal')
  WellbeingMetric.create!(team_member_id: rand(1..TeamMember.count), name: 'Employment/Education/Training', category: 'Personal')

  puts "Wellbeing Metrics\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
