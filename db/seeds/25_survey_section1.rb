survey = Survey.first

if survey.survey_sections.count.zero?
  print "#{pretty_print_name('Survey Section 1')}\tStart: #{pretty_print(Time.now - @start_time)}"

  section1 = survey.survey_sections.create!(order: 1, heading: 'Please tell us how the hub makes you feel...')

  section1.survey_questions.create!(order: 1, question: 'I feel I am treated fairly by staff at the Hub')
  section1.survey_questions.create!(order: 2, question: 'I feel listened to at the Hub')
  section1.survey_questions.create!(order: 3, question: 'I feel respected at the Hub')
  section1.survey_questions.create!(order: 4, question: 'I can trust staff at the Hub')
  section1.survey_questions.create!(order: 5, question: 'The Hub helps me to solve problems and improved my ability to cope')
  section1.survey_questions.create!(order: 6, question: 'The Hub helps me to make better choices')
  section1.survey_questions.create!(order: 7, question: 'I feel I have more choice in accessing services because of the Hub')
  section1.survey_questions.create!(order: 8, question: 'I use my time more positively @ the Hub')
  section1.survey_questions.create!(order: 9, question: 'The Hub provides me support')
  section1.survey_questions.create!(order: 10, question: 'The Hub has helped me to feel more positive and hopeful about my future')
  section1.survey_questions.create!(order: 11, question: 'The Hub makes me feel more positive about myself')
  section1.survey_questions.create!(order: 12, question: 'The Hub inspires me to make changes')
  section1.survey_questions.create!(order: 13, question: 'The Hub has provided me with advice')
  section1.survey_questions.create!(order: 14, question: 'The Hub has increased my access to services the help me')
  section1.survey_questions.create!(order: 15, question: 'The Hub has helped me to participate in positive activities of my choice')
  section1.survey_questions.create!(order: 16, question: 'The Hub has helped me to improve my communication skills')
  section1.survey_questions.create!(order: 17, question: 'The Hub has helped me to access IT')
  section1.survey_questions.create!(order: 18, question: 'The Hub has helped improve my confidence')
  section1.survey_questions.create!(order: 19, question: 'The Hub has given me training opportunities')
  section1.survey_questions.create!(order: 20, question: 'The Hub has given me volunteering opportunities')
  section1.survey_questions.create!(order: 21, question: 'The Hub has enabled me to make positive use of my time')
  section1.survey_questions.create!(order: 22, question: 'The Hub has helped me to improve my mental health')
  section1.survey_questions.create!(order: 23, question: 'The Hub has helped me to feel less lonely')
  section1.survey_questions.create!(order: 24, question: 'The Hub has helped me to improve my drug/alcohol issues')
  section1.survey_questions.create!(order: 25, question: 'The Hub makes me feel like a valued member of the community')
  section1.survey_questions.create!(order: 26, question: 'The Hub provides a safe environment where I feel I belong')
  section1.survey_questions.create!(order: 27, question: 'I feel my ideas and input count at the Hub')
  section1.survey_questions.create!(order: 28, question: 'I feel listened to at the Hub')
  section1.survey_questions.create!(order: 29, question: 'I feel connected with others at the Hub')
  section1.survey_questions.create!(order: 30, question: 'I feel included at the Hub')
  section1.survey_comment_sections.create!(
    order: 31,
    label: 'We appreciate your feedback\ if there is anything you would to add, please add your comments here:'
  )

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
