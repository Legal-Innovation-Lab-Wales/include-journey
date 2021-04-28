# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

total_user_count = 10
wellbeing_assessments_for_each_user = 200
journal_entries_for_each_user = 5
contacts_for_each_user = 5
crisis_events_count = 10
crisis_notes_count = 5
notes_count = 1000
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

unless TeamMember.find_by_email('g.d.andrews@swansea.ac.uk').present?
  team_member = TeamMember.new(
    first_name: 'Gareth',
    last_name: 'Andrews',
    email: 'g.d.andrews@swansea.ac.uk',
    mobile_number: '07890123456',
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
## Set up counter variables for tracking
user_counter = 0
wba_counter = 0
journal_counter = 0

if User.count.zero?
  total_user_count.times do
    user_counter += 1
    puts("Elapsed Time: #{Time.now - start_time}")
    puts("Creating User: #{user_counter}")
    user = User.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: "IJ-test-user-#{user_counter}@purpleriver.dev",
      mobile_number: Faker::Number.leading_zero_number(digits: 11),
      release_date: rand(1..2).even? ? Faker::Date.between(from: '2021-03-05', to: '2025-03-05') : '',
      terms: true,
      password: 'test1234'
    )
    user.skip_confirmation!
    user.save!

    ## Create User Wellbeing Assessments for each user
    user_wba_counter = 0
    wellbeing_assessments_for_each_user.times do
      wba_counter += 1
      user_wba_counter += 1
      created_at_value = DateTime.now - (wellbeing_assessments_for_each_user - user_wba_counter).day
      #puts("Creating Wellbeing Assessment #{user_wba_counter} for user #{user_counter} for date #{created_at_value}")

      wellbeing_assessment = WellbeingAssessment.create!(
        user: user,
        created_at: created_at_value
      )

      # Every 7th assessment is created by a TeamMember
      wellbeing_assessment.update!(team_member_id: rand(1..TeamMember.count)) if (wba_counter % 7).zero?

      WellbeingMetric.all.each do |wellbeing_metric|
        score_value =
          if user.wellbeing_assessments.second_to_last.present?
            (user.wellbeing_assessments.second_to_last.wba_scores.find_by(wellbeing_metric: wellbeing_metric).value + rand(-1..1)).clamp(1, 10)
          else
            rand(1..10)
          end
        WbaScore.create!(
          wellbeing_assessment: wellbeing_assessment,
          wellbeing_metric: wellbeing_metric,
          value: score_value,
          created_at: created_at_value
        )
      end
    end

    ## Create Journal Entries for each User
    journal_entries_for_each_user.times do
      journal_counter += 1
      created_at_value = Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now)
      # puts("Creating Journal #{journal_count} for user #{user_count}")
      journal_entry = JournalEntry.new(
        user: user,
        entry: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
        feeling: %w[😊 😔 😠 💩 😐].sample,
        created_at: created_at_value
      )
      journal_entry.save!

      ## Create permissions for each journal entry
      TeamMember.all.each do |team_member|
        JournalEntryPermission.create!(
          team_member: team_member,
          journal_entry: journal_entry,
          created_at: created_at_value
        )
      end

      ## Create View Log for every 7th journal entry
      next unless (journal_counter % 7).zero?

      TeamMember.all.each do |team_member|
        JournalEntryViewLog.create!(
          team_member: team_member,
          journal_entry: journal_entry,
          created_at: created_at_value + 1.day
        )
      end
    end

    contacts_for_each_user.times do
      name = Faker::Name.name
      Contact.create!(
        user: user,
        name: name,
        number: Faker::Number.leading_zero_number(digits: 11),
        email: Faker::Internet.email(name: name, separators: '-'),
        description: Faker::Job.position
      )
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

notes_counter = 1
notes_count.times do
  note = Note.create!(
    team_member_id: rand(1..TeamMember.count),
    visible_to_user: [true, false].sample,
    user_id: rand(1..User.count),
    content: Faker::TvShows::TheExpanse.quote
  )

  # Every fifth note is replaced by a new note to demonstrate the edit history functionality 
  if (notes_counter % 5).zero?
    new_note = Note.create!(
      team_member_id: note.team_member.id,
      visible_to_user: [true, false].sample,
      user_id: note.user.id,
      content: Faker::TvShows::TheExpanse.quote,
      replacing: note
    )

    note.update!(replaced_by: new_note)
    notes_counter += 1
  end

  notes_counter += 1
end

crisis_events_count.times do
  crisis_event = CrisisEvent.create!(
    additional_info: Faker::Hipster.sentences(number: 1)[0],
    user_id: rand(1..User.count),
    crisis_type_id: rand(1..CrisisType.count)
  )

  crisis_notes_count.times do |i|
    crisis_note = crisis_event.crisis_notes.create!(
      team_member_id: rand(1..TeamMember.count),
      content: Faker::Movies::HarryPotter.quote
    )

    next unless i.even?

    new_crisis_note = crisis_event.crisis_notes.create!(
      team_member_id: crisis_note.team_member_id,
      content: Faker::Movies::HarryPotter.quote,
      replacing: crisis_note
    )

    crisis_note.update!(replaced_by: new_crisis_note)
  end

  next unless [true, false].sample

  crisis_event.update!(
    closed: true,
    closed_at: Faker::Date.between(from: '2020-03-05', to: '2021-03-05'),
    closed_by: TeamMember.find(rand(1..TeamMember.count))
  )
end

puts("Team Members in DatabaseL #{TeamMember.count}")
puts("Users Created: #{user_counter}")
puts("Users in Database: #{User.count}")

puts("Contact per User: #{contacts_for_each_user}")
puts("Wellbeing Assessments Created: #{wba_counter}")
puts("Journals Created: #{journal_counter}")
puts("Crisis Events Created: #{crisis_events_count}")
puts("Notes per Crisis Event: #{crisis_notes_count}")
