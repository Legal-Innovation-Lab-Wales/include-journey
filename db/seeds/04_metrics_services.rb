# frozen_string_literal: true

if MetricsService.count.zero?
  print "#{pretty_print_name('Metrics Services')}\tStart: #{pretty_print(Time.current - @start_time)}"
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 5) # Include --> Behaviour
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 6) # Include --> Addiction
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 7) # Include --> Relationships
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 8) # Include --> Sense of Community
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 4) # Samaritans --> Physical Health
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 2) # Samaritans --> Mental Health
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 3) # Samaritans --> Emotional Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 4) # Mind --> Physical Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 2) # Mind --> Mental Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 3) # Mind --> Emotional Health
  MetricsService.create!(wellbeing_service_id: 4, wellbeing_metric_id: 9) # Shelter --> Housing
  MetricsService.create!(wellbeing_service_id: 5, wellbeing_metric_id: 10) # Citizens Advice --> Benefits/Money
  MetricsService.create!(wellbeing_service_id: 5, wellbeing_metric_id: 1) # Citizens Advice --> Employment/Education/Training
  MetricsService.create!(wellbeing_service_id: 6, wellbeing_metric_id: 11) # Food Banks --> Food

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
