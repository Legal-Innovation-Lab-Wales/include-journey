if WellbeingAssessment.count.zero?
  User.all.each do |user|
    Config::WELLBEING_ASSESSMENTS_FOR_EACH_USER.times do |index|
      created_at_value = DateTime.now - (Config::WELLBEING_ASSESSMENTS_FOR_EACH_USER - (index + 1))
      wellbeing_assessment = WellbeingAssessment.create!(user: user, created_at: created_at_value)

      # Every 7th assessment is created by a TeamMember
      wellbeing_assessment.update!(team_member_id: rand(1..TeamMember.count)) if (wellbeing_assessment.id % 7).zero?
    end
  end

  puts "Wellbeing Assessments\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
