# frozen_string_literal: true

class UserTag < ApplicationRecord
  belongs_to :tag
  belongs_to :user
  belongs_to :team_member

  scope :created_in_last_week, -> { where(user_tags: {created_at: 7.days.ago..}) }
  scope :created_in_last_month, -> { where(user_tags: {created_at: 1.month.ago..}) }

  validates :tag_id, :user_id, :team_member_id, presence: true
end
