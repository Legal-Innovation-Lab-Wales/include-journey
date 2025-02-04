# frozen_string_literal: true

# app/models/metrics_service.rb
class MetricsService < ApplicationRecord
  belongs_to :wellbeing_service
  belongs_to :wellbeing_metric
end
