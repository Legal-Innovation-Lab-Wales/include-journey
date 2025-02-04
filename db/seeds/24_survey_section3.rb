# frozen_string_literal: true

survey = Survey.first

if survey.survey_sections.count < 3
  print "#{pretty_print_name('Survey Section 3')}\tStart: #{pretty_print(Time.now - @start_time)}"

  section3 = survey.survey_sections.create!(
    order: 3,
    heading: 'Generally in the community',
    answer_labels: SurveySection::LIKERT_5_ANSWER_LABELS,
  )

  section3.survey_questions.create!(order: 1, question: 'I feel I belong')
  section3.survey_questions.create!(order: 2, question: 'I feel my ideas and input count')
  section3.survey_questions.create!(order: 3, question: 'I feel listened to')
  section3.survey_questions.create!(order: 4, question: 'I feel connected with others')
  section3.survey_questions.create!(order: 5, question: 'I feel included')
  section3.survey_questions.create!(order: 6, question: 'I feel I belong, I feel people care about me')
  section3.survey_questions.create!(order: 7, question: 'I feel like an outsider')
  section3.survey_questions.create!(order: 8, question: "I feel as if people don't care about me")
  section3.survey_questions.create!(order: 9, question: "I don't belong and feel worse during holiday seasons")
  section3.survey_questions.create!(order: 10, question: 'I feel isolated')
  section3.survey_questions.create!(order: 11, question: "Friends and family don't involve me in their plans")

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
