# app/models/ota_entry.rb

# This is a wallich-specific model file
# It is only used when ENV['ORGANISATION_NAME'] == 'wallich-journey'
class OtaEntry < ApplicationRecord
  belongs_to :occupational_therapist_assessment
  belongs_to :occupational_therapist_metric
  belongs_to :occupational_therapist_score

  def add_to_history(history)
    existing_dataset = history[:datasets].find { |dataset| dataset[:label] == occupational_therapist_metric.name }

    if existing_dataset.present?
      existing_dataset[:data] << point
    else
      history[:datasets].push({ label: occupational_therapist_metric.name, data: [point] })
    end
  end

  def point
    { x: created_at, y: occupational_therapist_score.value }
  end
end
