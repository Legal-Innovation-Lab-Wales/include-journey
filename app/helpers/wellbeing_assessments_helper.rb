# app/helpers/wellbeing_assessments_helper.rb
module WellbeingAssessmentsHelper

  def last_score(last_scores, wellbeing_metric_id)
    return 6 unless last_scores.present?

    last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
  end
end
