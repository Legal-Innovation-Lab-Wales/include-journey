if WellbeingService.count.zero?
  print "Wellbeing Services\tStart: #{Time.now - @start_time}"
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Include UK',
    description: 'Help for ex-offenders',
    website: 'https://include-uk.com',
    contact_number: '01792814792'
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Samaritans',
    description: 'Support phone line',
    website: 'https://www.samaritans.org',
    contact_number: '01792814792'
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Mind',
    description: 'Mental health charity',
    website: 'https://www.mind.org.uk',
    contact_number: '01792814792'
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Shelter',
    description: 'Housing support',
    website: 'https://www.shelter.org.uk',
    contact_number: '01792814792'
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Citizens Advice',
    description: 'Government Services',
    website: 'https://citizensadvicesnpt.org.uk',
    contact_number: '01792814792'
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Food Banks',
    description: 'Trussell Trust Food Bank Search',
    website: 'https://www.trusselltrust.org/get-help/find-a-foodbank',
    contact_number: '01792814792'
  )

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
