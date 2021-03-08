# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# Create users
## Create Static Users
unless TeamMember.find_by_email('philr@purpleriver.dev').present?
  team_member = TeamMember.new(
    first_name: 'Phil',
    last_name: 'Reynolds',
    email: 'philr@purpleriver.dev',
    mobile_number: '07888777666',
    admin: true,
    terms: true,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

unless TeamMember.find_by_email('a.j.wing@swansea.ac.uk').present?
  team_member = TeamMember.new(
    first_name: 'Alex',
    last_name: 'Wing',
    email: 'a.j.wing@swansea.ac.uk',
    mobile_number: '07777666555',
    admin: true,
    terms: true,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

unless TeamMember.find_by_email('ieuan.skinner@swansea.ac.uk').present?
  team_member = TeamMember.new(
    first_name: 'Ieuan',
    last_name: 'Skinner',
    email: 'ieuan.skinner@swansea.ac.uk',
    mobile_number: '07666555444',
    admin: true,
    terms: true,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

unless TeamMember.find_by_email('benmharrison@me.com').present?
  team_member = TeamMember.new(
    first_name: 'Ben',
    last_name: 'Harrison',
    email: 'benmharrison@me.com',
    mobile_number: '07555444333',
    admin: true,
    terms: true,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

if User.count.zero?
  10.times do
    user = User.new(
      first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name,
      email: Faker::Internet.unique.email,
      mobile_number: Faker::Number.leading_zero_number(digits: 11),
      release_date: rand(1..2).even? ? Faker::Date.between(from: '2021-03-05', to: '2025-03-05') : '',
      terms: true,
      password: 'password'
    )
    user.skip_confirmation!
    user.save!
  end
end

Note.create!(
  team_member_id: 1,
  visible_to_user: true,
  user_id: User.first.id,
  content: Faker::TvShows::TheExpanse.quote
)

if WellbeingMetric.count.zero?
  # id: 1
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Housing',
    category: 'Environment'
  )
  # id: 2
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Benefits / Money',
    category: 'Environment'
  )
  # id: 3
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Food',
    category: 'Environment'
  )
  # id: 4
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Physical Health',
    category: 'Health'
  )
  # id: 5
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Mental Health',
    category: 'Health'
  )
  # id: 6
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Emotional Health',
    category: 'Health'
  )
  # id: 7
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Behaviour',
    category: 'Personal'
  )
  # id: 8
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Addiction',
    category: 'Health'
  )
  # id: 9
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Relationships',
    category: 'Personal'
  )
  # id: 10
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Sense of Community ',
    category: 'Personal'
  )
  # id: 11
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Employment/Education/Training',
    category: 'Personal'
  )
end

if WbaSelf.count.zero?

  wbaselfcount = 0
  50.times do
    wbaselfcount += 1
    puts("Creating WbaSelf #{wbaselfcount}")

    WbaSelf.create!(
      # id: wbaselfcount
      user_id: rand(1..10)
    )

    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 1, # housing
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 2, # Benefits / Money
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 3,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 4,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 5,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 6,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 7,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 8,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 9,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 10,
      value: rand(1..10)
    )
    WbaSelfScore.create!(
      wba_self_id: wbaselfcount,
      wellbeing_metric_id: 11,
      value: rand(1..10)
    )
    WbaSelfPermission.create!(
      wba_self_id: wbaselfcount,
      team_member_id: 1
    )
    WbaSelfPermission.create!(
      wba_self_id: wbaselfcount,
      team_member_id: 2
    )
    WbaSelfPermission.create!(
      wba_self_id: wbaselfcount,
      team_member_id: 3
    )
    WbaSelfPermission.create!(
      wba_self_id: wbaselfcount,
      team_member_id: 4
    )
  end
end

CrisisType.create!(
  # id: 1
  category: 'SELF HARM',
  team_member_id: 1,
)

CrisisType.create!(
  # id: 2
  category: 'HARMING OTHERS',
  team_member_id: 1,
)

CrisisType.create!(
  # id: 3
  category: 'SUICIDE',
  team_member_id: 1,
)

CrisisType.create!(
  # id: 4
  category: 'OVER DOSE',
  team_member_id: 1,
)

CrisisType.create!(
  # id: 5
  category: 'DOMESTIC VIOLENCE',
  team_member_id: 1,
)

10.times do

  isClosed = [true, false].sample

  if isClosed

    CrisisEvent.create!(
      additional_info: Faker::Hipster.sentences(number: 1),
      closed: true,
      closed_at: Faker::Date.between(from: '2020-03-05', to: '2021-03-05'),
      closed_by: TeamMember.first,
      user_id: rand(1..10),
      crisis_type_id: rand(1..5)
    )
  else
    CrisisEvent.create!(
      additional_info: Faker::Hipster.sentences(number: 1),
      user_id: rand(1..10),
      crisis_type_id: rand(1..5)
    )
  end
end


wbaselfcount = WbaSelf.count

WbaSelfViewLog.create!(
  wba_self_id: rand(1..wbaselfcount),
  team_member_id: rand(1..4)
)



10.times do
  WbaTeamMember.create!(
    team_member_id: rand(1..4),
    user_id: rand(1..10),
    )
end


wbaTeamMemberCount = WbaTeamMember.count

10.times do
  WbaTeamMemberScore.create!(
    wba_team_member_id: rand(1..wbaTeamMemberCount) ,
    wellbeing_metric_id: rand(1..11),
    value: rand(1..10),
    priority: rand(1..3)

  )
end