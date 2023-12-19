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
