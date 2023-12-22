# app/models/occupational_therapist_score.rb

# This is a wallich-specific model file
# It is only used when ENV['ORGANISATION_NAME'] == 'wallich-journey'
class OccupationalTherapistScore < ApplicationRecord
  has_many :ota_entries

  OPTIONS = [
    '1',
    '2',
    '3',
    '4',
    '5',
    'N/A'
  ].freeze

  validates_presence_of :value
  validates :value, inclusion: { in: OPTIONS }
end
