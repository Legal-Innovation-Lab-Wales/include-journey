if OccupationalTherapistAssessment.count.zero? && ENV['ORGANISATION_NAME'] == 'wallich-journey'
  print "#{pretty_print_name('Occupational Therapist Assessment')}\tStart: #{pretty_print(Time.now - @start_time)}"

  # Create Occupational Therapist Metric
  metrics = [
    'Learning And Applying Knowledge',
    'Functional Walking And Mobility',
    'Upper Limb Use',
    'Carrying Out Daily Life Tasks And Routines',
    'Transfers',
    'Using Transport',
    'Self Care',
    'Domestic Life - Home',
    'Domestic Life - Managing Resources',
    'Interpersonal Interactions And Relationships',
    'Work, Employment And Education',
    'Community Life, Recreation, Leisure And Play'
  ]

  metrics.each do |metric|
    OccupationalTherapistMetric.create!(name: metric)
  end

  # Create Occupational Therapist Score
  scores = ['1', '2', '3', '4', '5', 'N/A']

  scores.each do |score|
    OccupationalTherapistScore.create!(value: score)
  end

  # Search for a specific user
  user = User.find_by_email('ij-test-user-10@purpleriver.dev')

  # Method for created OccupationalTherapistAssessment
  10.times do
    # randomly selected team member
    team_member = user.team_members.all.sample

    ota = OccupationalTherapistAssessment.create!(
      team_member: team_member,
      user: user
    )

    # Create associated OtaEntries (AssessmentEntries) with a random metric and score
    OccupationalTherapistMetric.all.each do |metric|
      score = OccupationalTherapistScore.all.sample

      OtaEntry.create!(
        occupational_therapist_assessment: ota,
        occupational_therapist_metric: metric,
        occupational_therapist_score: score
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
