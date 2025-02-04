# frozen_string_literal: true

survey = Survey.first

if survey.survey_sections.count < 4
  print "#{pretty_print_name('Survey Section 4')}\tStart: #{pretty_print(Time.now - @start_time)}"

  section4 = survey.survey_sections.create!(order: 4)

  section4.survey_comment_sections.create!(order: 1, label: 'Please add any feedback about Include Journey:')
  section4.survey_comment_sections.create!(
    order: 2,
    label: 'Please add any feedback about other services you have received:',
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
