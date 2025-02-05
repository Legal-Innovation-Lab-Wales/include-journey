# frozen_string_literal: true

if Config::SURVEY_RESPONSES
  print "#{pretty_print_name('Survey Responses')}\tStart: #{pretty_print(Time.current - @start_time)}"

  survey = Survey.includes(:survey_sections).first
  survey_sections = survey.survey_sections.includes(:survey_questions, :survey_comment_sections)

  User.find_each do |user|
    response = SurveyResponse.create!(user: user, survey: survey)

    survey_sections.each do |survey_section|
      survey_section.survey_questions.each do |question|
        SurveyAnswer.create!(survey_question: question, survey_response: response, answer: rand(0..5))
      end

      survey_section.survey_comment_sections.each do |comment_section|
        SurveyComment.create!(
          text: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
          survey_comment_section: comment_section,
          survey_response: response,
        )
      end
    end

    response.update!(submitted_at: Time.current)
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
