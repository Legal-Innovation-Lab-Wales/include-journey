# frozen_string_literal: true

# app/helpers/wellbeing_assessments_helper.rb
module WellbeingAssessmentsHelper
  def last_score(last_scores, wellbeing_metric_id)
    return 6 unless last_scores.present?

    last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
  end

  def score_description(score)
    score <= 10 ? WellbeingScoreValue.find(score).name : 'Unknown'
  end
end
