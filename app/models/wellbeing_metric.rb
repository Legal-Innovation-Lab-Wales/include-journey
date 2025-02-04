# frozen_string_literal: true

# app/models/wellbeing_metric.rb
class WellbeingMetric < ApplicationRecord
  belongs_to :team_member

  has_many :wba_self_scores
  has_many :wba_team_member_scores
  has_many :metrics_services
  has_many :wellbeing_services, through: :metrics_services

  validates :name, :category, :icon, :colour, presence: true
  validates :name, :category, format: {with: Rails.application.config.regex_name}
end
