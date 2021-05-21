if MetricsService.count.zero?
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 7) # Include --> Behaviour
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 8) # Include --> Addiction
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 9) # Include --> Relationships
  MetricsService.create!(wellbeing_service_id: 1, wellbeing_metric_id: 10) # Include --> Sense of Community
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 4) # Samaritans --> Physical Health
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 5) # Samaritans --> Mental Health
  MetricsService.create!(wellbeing_service_id: 2, wellbeing_metric_id: 6) # Samaritans --> Emotional Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 4) # Mind --> Physical Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 5) # Mind --> Mental Health
  MetricsService.create!(wellbeing_service_id: 3, wellbeing_metric_id: 6) # Mind --> Emotional Health
  MetricsService.create!(wellbeing_service_id: 4, wellbeing_metric_id: 1) # Shelter --> Housing
  MetricsService.create!(wellbeing_service_id: 5, wellbeing_metric_id: 2) # Citizens Advice --> Benefits/Money
  MetricsService.create!(wellbeing_service_id: 5, wellbeing_metric_id: 11) # Citizens Advice --> Employment/Education/Training
  MetricsService.create!(wellbeing_service_id: 6, wellbeing_metric_id: 3) # Food Banks --> Food

  puts "Metrics Services\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end