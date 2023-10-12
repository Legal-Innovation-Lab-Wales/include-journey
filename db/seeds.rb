begin
  require_relative 'config' # config file not in load path - require_relative searches current file location for config
rescue LoadError
  puts 'Config file "db/config.rb" not found'
  puts 'Check README.md for details on creating the config file'
  exit
end

require 'faker'

@start_time = Time.now

MAX_NAME_LENGTH = 22
MAX_TIME_LENGTH = 6
DOTTED_LINE_LENGTH = MAX_NAME_LENGTH + (MAX_TIME_LENGTH * 3) + ('Start: '.length + 'Duration: '.length + 'Elapsed: '.length) + 8 # Tabs

def pretty_print_name(name)
  name = name[0..(MAX_NAME_LENGTH - 1)] if name.length > MAX_NAME_LENGTH
  name + (' ' * (MAX_NAME_LENGTH - name.length))
end

def pretty_print(value)
  str = value.to_f.to_s
  if str.length < MAX_TIME_LENGTH
    str + ('0' * (MAX_TIME_LENGTH - str.length))
  else
    str[0..(MAX_TIME_LENGTH - 1)]
  end
end

puts ('-' * DOTTED_LINE_LENGTH).to_s
puts 'Running Seeds'
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

unless User.find_by_email('john.smith@me.com').present?
  user = User.new(
    first_name: 'John',
    last_name: 'Smith',
    email: 'john.smith@me.com',
    mobile_number: Faker::Number.leading_zero_number(digits: 11),
    terms: true,
    password: 'password'
  )
  user.save!
end

puts ('-' * DOTTED_LINE_LENGTH).to_s
puts 'Counts'
puts("#{pretty_print_name('Team Members')}\t#{TeamMember.count}")
puts("#{pretty_print_name('Users')}\t#{User.count}")
puts("#{pretty_print_name('User Profile View Logs')}\t#{UserProfileViewLog.count}")
puts("#{pretty_print_name('Wellbeing Metrics')}\t#{WellbeingMetric.count}")
puts("#{pretty_print_name('Wellbeing Services')}\t#{WellbeingService.count}")
puts("#{pretty_print_name('Metrics Services')}\t#{MetricsService.count}")
puts("#{pretty_print_name('Wellbeing Assessments')}\t#{WellbeingAssessment.count}")
puts("#{pretty_print_name('WBA Scores')}\t#{WbaScore.count}")
puts("#{pretty_print_name('Contacts')}\t#{Contact.count}")
puts("#{pretty_print_name('Goals')}\t#{Goal.count}")
puts("#{pretty_print_name('Appointments')}\t#{Appointment.count}")
puts("#{pretty_print_name('Notes')}\t#{Note.count}")
puts("#{pretty_print_name('Diary Entries')}\t#{DiaryEntry.count}")
puts("#{pretty_print_name('Diary Permissions')}\t#{DiaryEntryPermission.count}")
puts("#{pretty_print_name('Diary View Logs')}\t#{DiaryEntryViewLog.count}")
puts("#{pretty_print_name('Tags')}\t#{Tag.count}")
puts("#{pretty_print_name('User Tags')}\t#{UserTag.count}")
puts("#{pretty_print_name('Affirmations')}\t#{Affirmation.count}")
puts("#{pretty_print_name('Survey')}\t#{Survey.count}")
puts("#{pretty_print_name('Survey Sections')}\t#{SurveySection.count}")
puts("#{pretty_print_name('Survey Questions')}\t#{SurveyQuestion.count}")
puts("#{pretty_print_name('Survey Comment Sections')}\t#{SurveyCommentSection.count}")
puts("#{pretty_print_name('Survey Responses')}\t#{SurveyResponse.count}")
puts("#{pretty_print_name('Sessions')}\t#{Session.count}")
puts("#{pretty_print_name('Achievements')}\t#{Achievement.count}")
puts("#{pretty_print_name('Messages')}\t#{Message.count}")
puts("#{pretty_print_name('Folders')}\t#{Folder.count}")
puts("#{pretty_print_name('Accommodation Types')}\t#{AccommodationType.count}")
puts("#{pretty_print_name('Housing Providers')}\t#{HousingProvider.count}")
puts("#{pretty_print_name('Reasons Ending Support')}\t#{SupportEndingReason.count}")
puts("#{pretty_print_name('Referred Froms')}\t#{ReferredFrom.count}")
puts("#{pretty_print_name('Priorities')}\t#{Priority.count}")
puts("#{pretty_print_name('Wallich Local Authorities')}\t#{WallichLocalAuthority.count}")
puts("#{pretty_print_name('Emergency Contacts')}\t#{EmergencyContact.count}")
