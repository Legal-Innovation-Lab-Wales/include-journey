# app/helpers/surveys_helper.rb
module SurveysHelper
  def answer_pct(question, answer)
    format('%.2f', (question["answer#{answer}"].to_f / question.total) * 100)
  end
end
