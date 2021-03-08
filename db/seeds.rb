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
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Housing',
    category: 'Environment'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Benefits / Money',
    category: 'Environment'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Food',
    category: 'Environment'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Physical Health',
    category: 'Health'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Mental Health',
    category: 'Health'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Emotional Health',
    category: 'Health'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Behaviour',
    category: 'Personal'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Addiction',
    category: 'Health'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Relationships',
    category: 'Personal'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Sense of Community',
    category: 'Personal'
  )
  WellbeingMetric.create!(
    team_member_id: 1,
    name: 'Employment/Education/Training',
    category: 'Personal'
  )
end

if WbaSelf.count.zero?

  50.times do |wbaselfcount|
    wbaselfcount += 1
    puts("Creating WbaSelf #{wbaselfcount}")

    WbaSelf.create!(
      user_id: rand(1..10)
    )

    WellbeingMetric.count.times do |wellbeing_metric_id|
      WbaSelfScore.create!(
        wba_self_id: wbaselfcount,
        wellbeing_metric_id: wellbeing_metric_id+1, # housing
        value: rand(1..10)
      )
    end

    TeamMember.count.times do |id|
      WbaSelfPermission.create!(
        wba_self_id: wbaselfcount,
        team_member_id: id+1
      )

      WbaSelfViewLog.create!(
        wba_self_id: wbaselfcount,
        team_member_id: id+1
      )
    end
  end
end

CrisisType.create!(
  category: 'SELF HARM',
  team_member_id: 1,
)

CrisisType.create!(
  category: 'HARMING OTHERS',
  team_member_id: 1,
)

CrisisType.create!(
  category: 'SUICIDE',
  team_member_id: 1,
)

CrisisType.create!(
  category: 'OVER DOSE',
  team_member_id: 1,
)

CrisisType.create!(
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

if WbaTeamMember.count.zero?
  10.times do |wba_team_member_count|
    wba_team_member_count += 1
    puts("Creating WbaTeamMember #{wba_team_member_count}")

    WbaTeamMember.create!(
      team_member_id: rand(1..4),
      user_id: rand(1..10),
    )

    WellbeingMetric.count.times do |wellbeing_metric_id|
      WbaTeamMemberScore.create!(
        wba_team_member_id: wba_team_member_count,
        wellbeing_metric_id: wellbeing_metric_id + 1,
        value: rand(1..10)
      )
    end
  end
end
