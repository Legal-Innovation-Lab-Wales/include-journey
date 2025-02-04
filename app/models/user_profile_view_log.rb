# frozen_string_literal: true

# app/models/user_profile_view_log.rb
class UserProfileViewLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :user

  scope :viewed_in_last_week, -> { where('user_profile_view_logs.updated_at >= ?', 1.week.ago) }
  scope :viewed_in_last_month, -> { where('user_profile_view_logs.updated_at >= ?', 1.month.ago) }

  validates :team_member_id, :user_id, presence: true

  def increment_view_count
    self.view_count += 1
  end
end
