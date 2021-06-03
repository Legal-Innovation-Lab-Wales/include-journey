begin
  require_relative 'config' # config file not in load path - require_relative searches current file location for config
rescue LoadError
  puts 'Config file "db/config.rb" not found'
  puts 'Check README.md for details on creating the config file'
  exit
end

require 'faker'

@start_time = Time.now

puts ('-' * 50).to_s
puts 'Running Seeds'
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

unless User.find_by_email('john.smith@me.com').present?
  user = User.new(
    first_name: 'John',
    last_name: 'Smith',
    email: 'john.smith@me.com',
    mobile_number: Faker::Number.leading_zero_number(digits: 11),
    release_date: rand(1..2).even? ? Faker::Date.between(from: DateTime.now - 20.days, to: DateTime.now) : '',
    terms: true,
    password: 'password'
  )
  user.skip_confirmation!
  user.save!
end

puts ('-' * 50).to_s
puts 'Counts'
puts("Team Members\t\t#{TeamMember.count}")
puts("Users\t\t\t#{User.count}")
puts("User Profile View Logs\t#{UserProfileViewLog.count}")
puts("Wellbeing Metrics\t#{WellbeingMetric.count}")
puts("Wellbeing Services\t#{WellbeingService.count}")
puts("Metrics Services\t#{MetricsService.count}")
puts("Wellbeing Assessments\t#{WellbeingAssessment.count}")
puts("WBA Scores\t\t#{WbaScore.count}")
puts("Contacts\t\t#{Contact.count}")
puts("Goals\t\t\t#{Goal.count}")
puts("Appointments\t\t#{Appointment.count}")
puts("Notes\t\t\t#{Note.count}")
puts("Journal Entries\t\t#{JournalEntry.count}")
puts("Journal Permissions\t#{JournalEntryPermission.count}")
puts("Journal View Logs\t#{JournalEntryViewLog.count}")
puts("Crisis Events\t\t#{CrisisEvent.count}")
puts("Crisis Notes\t\t#{CrisisNote.count}")
puts("Tags\t\t\t#{Tag.count}")
puts("User Tags\t\t#{UserTag.count}")
