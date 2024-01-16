# app/models/ota_entry.rb

# This is a wallich-specific model file
# It is only used when ENV['ORGANISATION_NAME'] == 'wallich-journey'
class OtaEntry < ApplicationRecord
  belongs_to :occupational_therapist_assessment
  belongs_to :occupational_therapist_metric
  belongs_to :occupational_therapist_score
end
