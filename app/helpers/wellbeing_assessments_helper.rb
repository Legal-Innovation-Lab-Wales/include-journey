# app/helpers/wellbeing_assessments_helper.rb
module WellbeingAssessmentsHelper

  def last_score(last_scores, wellbeing_metric_id)
    return 6 unless last_scores.present?

    last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
  def score_description(score)
    case score
    when 1
      'Abysmal'
    when 2
      'Dreadful'
    when 3
      'Rubbish'
    when 4
      'Bad'
    when 5
      'Mediocre'
    when 6
      'Fine'
    when 7
      'Good'
    when 8
      'Great'
    when 9
      'Superb'
    when 10
      'Perfect'
    else
      'Unknown'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength
end
