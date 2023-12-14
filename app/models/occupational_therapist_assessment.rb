class OccupationalTherapistAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member
  has_many :ota_entries, dependent: :destroy
end
