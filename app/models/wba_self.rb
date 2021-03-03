class WbaSelf < ApplicationRecord
  belongs_to :user

  has_many :wba_self_scores, foreign_key: true
  has_many :wba_self_permissions, foreign_key: true
  has_many :wba_self_view_logs, foreign_key: true
end
