# app/models/occupational_therapist_assessment.rb

# This is a wallich-specific model file
# It is only used when ENV['ORGANISATION_NAME'] == 'wallich-journey'
class OccupationalTherapistAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member
  has_many :ota_entries, dependent: :destroy
end
