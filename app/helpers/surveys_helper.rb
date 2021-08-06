# app/helpers/surveys_helper.rb
module SurveysHelper
  def survey_option(index)
    return 'Unknown' unless index < 6 && index >= 0

    ['Strongly Disagree', 'Disagree', 'Neither Agree Or Disagree', 'Agree', 'Strongly Agree', 'Not Applicable'][index]
  end
end
