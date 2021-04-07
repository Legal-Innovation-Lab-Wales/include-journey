# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

total_user_count = 10
wellbeing_assessments_for_each_user = 30
journal_entries_for_each_user = 5
crisis_events_count = 100
notes_count = 100
start_time = Time.now

# Create Static Team Members
unless TeamMember.find_by_email('philr@purpleriver.dev').present?
  team_member = TeamMember.new(
    first_name: 'Phil',
    last_name: 'Reynolds',
    email: 'philr@purpleriver.dev',
    mobile_number: '07888777666',
    admin: true,
    approved: true,
    terms: true,
    paused: false,
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
    paused: false,
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
    paused: false,
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
    paused: false,
    password: 'password'
  )
  team_member.skip_confirmation!
  team_member.save!
end

# Create Wellbeing Metrics
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

# Create Crisis Types
if CrisisType.count.zero?
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
end

# Create Service Users & Associated Records
user_count = 20
wba_count = 1
journal_count = 10
if User.count.zero?
  total_user_count.times do
    user_count += 1
    puts("Creating User: #{user_count}")
    puts("Elapsed Time: #{Time.now - start_time}")
    user = User.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: "IJ-test-user-#{user_count}@purpleriver.dev",
      mobile_number: Faker::Number.leading_zero_number(digits: 11),
      release_date: rand(1..2).even? ? Faker::Date.between(from: '2021-03-05', to: '2025-03-05') : '',
      terms: true,
      password: 'test1234'
    )
    user.skip_confirmation!
    user.save!

    ## Create User Wellbeing Assessments for each user
    wellbeing_assessments_for_each_user.times do
      wba_count += 1
      # puts("Creating Wellbeing Assessment #{wba_count} for user #{user_count}")

      wellbeing_assessment = WellbeingAssessment.create!(
        user: user,
        created_at: Date.today - (wba_count - 1),
        updated_at: Date.today - (wba_count - 1)
      )

      wellbeing_assessment.update!(team_member_id: rand(1..TeamMember.count)) if (wba_count % 5).zero?

      WellbeingMetric.all.each do |wellbeing_metric|
        WbaScore.create!(
          wellbeing_assessment: wellbeing_assessment,
          wellbeing_metric: wellbeing_metric,
          value: rand(1..10),
          created_at: Date.today - (wba_count - 1),
          updated_at: Date.today - (wba_count - 1)
        )
      end
    end

    ## Create Journal Entries for each User
    journal_entries_for_each_user.times do
      journal_count += 1
      # puts("Creating Journal #{journal_count} for user #{user_count}")
      journal_entry = JournalEntry.new(
        user: user,
        entry: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
        feeling: %w[😊 😔 😠 💩 😐].sample
      )
      journal_entry.save!

      ## Create permissions for each journal entry
      TeamMember.all.each do |team_member|
        JournalEntryPermission.create!(
          team_member: team_member,
          journal_entry: journal_entry
        )
      end

      ## Create View Log for every 5th journal entry
      next unless (journal_count % 5).zero?

      TeamMember.all.each do |team_member|
        JournalEntryViewLog.create!(
          team_member: team_member,
          journal_entry: journal_entry
        )
      end
    end
  end

  user = User.new(
    first_name: 'John',
    last_name: 'Smith',
    email: 'john.smith@me.com',
    mobile_number: Faker::Number.leading_zero_number(digits: 11),
    release_date: rand(1..2).even? ? Faker::Date.between(from: '2021-03-05', to: '2025-03-05') : '',
    terms: true,
    password: 'password'
  )
  user.skip_confirmation!
  user.save!
end

notes_count.times do
  Note.create!(
    team_member_id: rand(1..TeamMember.count),
    visible_to_user: true,
    user_id: rand(1..User.count),
    content: Faker::TvShows::TheExpanse.quote
  )
end

crisis_events_count.times do
  crisis_event = CrisisEvent.create!(
    additional_info: Faker::Hipster.sentences(number: 1)[0],
    user_id: rand(1..User.count),
    crisis_type_id: rand(1..CrisisType.count)
  )

  next unless [true, false].sample

  crisis_event.update!(
    closed: true,
    closed_at: Faker::Date.between(from: '2020-03-05', to: '2021-03-05'),
    closed_by: TeamMember.find(rand(1..TeamMember.count))
  )
end

puts("Team Members in DatabaseL #{TeamMember.count}")
puts("Users Created: #{user_count}")
puts("Users in Database: #{User.count}")

puts("Wellbeing Assessments Created: #{wba_count}")
puts("Journals Created: #{journal_count}")
