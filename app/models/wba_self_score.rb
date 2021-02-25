class WbaSelfScore < ApplicationRecord
  belongs_to :wba_self
  belongs_to :wellbeing_metric
end
