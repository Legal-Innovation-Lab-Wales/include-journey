# frozen_string_literal: true

if WellbeingService.count.zero?
  print "#{pretty_print_name('Wellbeing Services')}\tStart: #{pretty_print(Time.now - @start_time)}"
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Include UK',
    description: 'Help for ex-offenders',
    website: 'https://include-uk.com',
    contact_number: '01792814792',
    address: '2 Humphrey Street, Swansea',
    postcode: 'SA1 6BG',
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Samaritans',
    description: 'Support phone line',
    website: 'https://www.samaritans.org',
    contact_number: '01792814792',
    address: '2 Humphrey Street, Swansea',
    postcode: 'SA1 6BH',
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Mind',
    description: 'Mental health charity',
    website: 'https://www.mind.org.uk',
    contact_number: '01792814792',
    address: '66 St. Helens Road, Swansea',
    postcode: 'SA1 4BE',
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Shelter',
    description: 'Housing support',
    website: 'https://www.shelter.org.uk',
    contact_number: '01792814792',
    address: '25 Walter Road, Swansea',
    postcode: 'SA1 5NN',
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Citizens Advice',
    description: 'Government Services',
    website: 'https://citizensadvicesnpt.org.uk',
    contact_number: '01792814792',
    address: '2 Humphrey Street, Swansea',
    postcode: 'SA1 6JG',
  )
  WellbeingService.create!(
    team_member_id: rand(1..TeamMember.count),
    name: 'Food Banks',
    description: 'Trussell Trust Food Bank Search',
    website: 'https://www.trusselltrust.org/get-help/find-a-foodbank',
    contact_number: '01792814792',
    address: '2 Humphrey Street, Swansea',
    postcode: 'SA1 3BG',
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
