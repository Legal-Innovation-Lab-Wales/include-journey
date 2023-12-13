if OccupationalTherapistScore.count.zero?
  print "#{pretty_print_name('Occupational Therapist Score')}\tStart: #{pretty_print(Time.now - @start_time)}"

  # Search for a user with email
  user = User.find_by_email('ij-test-user-10@purpleriver.dev')

  ['0', '1', '2', '3', '4', '5', 'N/A'].each do |value|
    # randomly select a team member for every iteration
    team_member = user.team_members.all.sample

    # create ot_score with for the user and a randomly selected team member
    OccupationalTherapistScore.create!(
      user: user,
      team_member: team_member,
      learning_and_applying_knowledge: value,
      functional_walking_and_mobility: value,
      upper_limb_use: value,
      carrying_out_daily_life_tasks_and_routines: value,
      transfers: value,
      using_transport: value,
      self_care: value,
      domestic_life_home: value,
      domestic_life_managing_resources: value,
      interpersonal_interactions_and_relationships: value,
      work_employment_and_education: value,
      community_life_recreation_leisure_and_play: value,
      participation_restriction: value,
      distress_or_wellbeing: value
    )
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
