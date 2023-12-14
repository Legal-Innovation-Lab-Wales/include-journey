class OtaEntry < ApplicationRecord
  belongs_to :occupational_therapist_assessment
  belongs_to :occupational_therapist_metric
  belongs_to :occupational_therapist_score
end
