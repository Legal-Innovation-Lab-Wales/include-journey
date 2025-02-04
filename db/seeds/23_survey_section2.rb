# frozen_string_literal: true

survey = Survey.first

if survey.survey_sections.count < 2
  print "#{pretty_print_name('Survey Section 2')}\tStart: #{pretty_print(Time.now - @start_time)}"

  section2 = survey.survey_sections.create!(
    order: 2,
    heading: 'At the Hub...',
    answer_labels: SurveySection::LIKERT_5_ANSWER_LABELS,
  )

  section2.survey_questions.create!(order: 1, question: 'I feel I belong')
  section2.survey_questions.create!(order: 2, question: 'I feel my ideas and input count')
  section2.survey_questions.create!(order: 3, question: 'I feel listened to')
  section2.survey_questions.create!(order: 4, question: 'I feel connected with others')
  section2.survey_questions.create!(order: 5, question: 'I feel included')
  section2.survey_questions.create!(order: 6, question: 'I feel I belong, I feel people care about me')
  section2.survey_questions.create!(order: 7, question: 'I feel like an outsider')
  section2.survey_questions.create!(order: 8, question: "I feel as if people don't care about me")
  section2.survey_questions.create!(order: 9, question: "I don't belong and feel worse during holiday seasons")
  section2.survey_questions.create!(order: 10, question: 'I feel isolated')
  section2.survey_questions.create!(order: 11, question: "Friends and family don't involve me in their plans")

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
