# frozen_string_literal: true

if WellbeingAssessment.none?
  print "#{pretty_print_name('Wellbeing Assessments')}\tStart: #{pretty_print(Time.current - @start_time)}"
  User.find_each do |user|
    Config::WELLBEING_ASSESSMENTS_FOR_EACH_USER.times do |index|
      created_at_value = Time.current - (Config::WELLBEING_ASSESSMENTS_FOR_EACH_USER - (index + 1))
      wellbeing_assessment = WellbeingAssessment.create!(user: user, created_at: created_at_value)

      # Every 7th assessment is created by a TeamMember
      wellbeing_assessment.update!(team_member_id: rand(1..TeamMember.count)) if (wellbeing_assessment.id % 7).zero?
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
