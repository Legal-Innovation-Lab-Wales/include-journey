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
    approved: true,
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
    approved: true,
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
    approved: true,
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
    approved: true,
    terms: true,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

if User.count.zero?
  user_count = 0
  10.times do
    user_count += 1
    user = User.new(
      first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name,
      email: 'IJ-test-user-'+user_count.to_s+'@purpleriver.dev',
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

if WellbeingAssessment.count.zero?

  50.times do |wba_count|
    wba_count += 1
    puts("Creating Wellbeing Asessment #{wba_count}")

    WellbeingAssessment.create!(
      user_id: rand(1..10)
    )

    WellbeingMetric.count.times do |wellbeing_metric_id|
      WbaScore.create!(
        wellbeing_assessment_id: wba_count,
        wellbeing_metric_id: wellbeing_metric_id + 1,
        value: rand(1..10)
      )
    end
  end
end

CrisisType.create!(
  category: 'Self Harm',
  team_member_id: 1
)

CrisisType.create!(
  category: 'Harming Others',
  team_member_id: 1
)

CrisisType.create!(
  category: 'Suicide',
  team_member_id: 1
)

CrisisType.create!(
  category: 'Overdose',
  team_member_id: 1
)

CrisisType.create!(
  category: 'Domestic Violence',
  team_member_id: 1
)

10.times do

  is_closed = [true, false].sample

  if is_closed
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
