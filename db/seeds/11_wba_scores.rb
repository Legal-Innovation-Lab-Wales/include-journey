if WbaScore.count.zero?
  print "#{pretty_print_name('WBA Scores')}\tStart: #{pretty_print(Time.now - @start_time)}"
  User.all.each do |user|
    wellbeing_assessments = user.wellbeing_assessments.order(:id)
    wellbeing_assessments.each_with_index do |wellbeing_assessment, index|
      total = 0
      WellbeingMetric.all.each do |wellbeing_metric|
        score_value =
          if index.positive?
            # Users wba_score for a given metric will only increment by +/- 1
            (wellbeing_assessments[index - 1].wba_scores.find_by(wellbeing_metric: wellbeing_metric).value + rand(-1..1)).clamp(
              1, 10
            )
          else
            rand(1..10)
          end

        WbaScore.create!(
          wellbeing_assessment: wellbeing_assessment,
          wellbeing_metric: wellbeing_metric,
          value: score_value,
          created_at: wellbeing_assessment.created_at
        )

        total += score_value
      end
      wellbeing_assessment.update!(average: total.to_f / WellbeingMetric.count)
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
