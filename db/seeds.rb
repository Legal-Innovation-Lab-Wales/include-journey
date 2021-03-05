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
      release_date: rand(1..2).even? ? Faker::Date.between(from: '20201-03-05', to: '2025-03-05') : '',
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

WbaSelf.create!(
  # id: 1
  user_id: User.first.id
)

WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 1, # housing
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 2, # Benefits / Money
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 3,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 4,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 5,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 6,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 7,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 8,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 9,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 10,
  value: rand(1..10)
)
WbaSelfScore.create!(
  wba_self_id: 1,
  wellbeing_metric_id: 11,
  value: rand(1..10)
)

WbaSelfPermission.create!(
  wba_self_id: 1,
  team_member_id: 1
)
