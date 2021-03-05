class WbaSelf < ApplicationRecord
  belongs_to :user

  has_many :wba_self_scores, foreign_key: :wba_self_id
  has_many :wba_self_permissions, foreign_key: :wba_self_id
  has_many :wba_self_view_logs, foreign_key: :wba_self_id
end