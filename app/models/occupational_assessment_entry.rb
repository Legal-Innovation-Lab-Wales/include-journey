class OccupationalAssessmentEntry < ApplicationRecord
  belongs_to :occupational_therapist_assessment
  belongs_to :occupaional_therapist_metric
  belongs_to :occupational_therapist_score
end
