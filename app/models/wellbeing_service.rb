# app/models/wellbeing_service.rb
class WellbeingService < ApplicationRecord
  belongs_to :team_member

  has_many :metrics_services
  has_many :wellbeing_metrics, through: :metrics_services

  validates_presence_of :name, :link
end
