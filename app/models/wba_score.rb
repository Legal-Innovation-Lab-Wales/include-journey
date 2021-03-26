# app/models/wba_self_score.rb
class WbaScore < ApplicationRecord
  belongs_to :wellbeing_assessment
  belongs_to :wellbeing_metric
end
