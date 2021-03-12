# app/models/wba_self_score.rb
class WbaSelfScore < ApplicationRecord
  belongs_to :wba_self
  belongs_to :wellbeing_metric
end
