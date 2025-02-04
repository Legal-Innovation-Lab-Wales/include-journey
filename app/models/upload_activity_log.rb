# frozen_string_literal: true

# app/models/upload_activity_log.rb
class UploadActivityLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :upload

  ACTIVITY_TYPES = ['viewed', 'modified', 'downloaded', 'approved', 'rejected'].freeze

  validates :activity_type, :activity_time, presence: true
  validates :activity_type, inclusion: {in: ACTIVITY_TYPES}

  scope :viewed_in_last_week, -> { where(activity_type: 'viewed', activity_time: 1.week.ago..) }
  scope :viewed_in_last_month, -> { where(activity_type: 'viewed', activity_time: 1.month.ago..) }

  scope :modified_in_last_week, -> { where(activity_type: 'modified', activity_time: 1.week.ago..) }
  scope :modified_in_last_month, -> { where(activity_type: 'modified', activity_time: 1.month.ago..) }

  scope :downloaded_in_last_week, -> { where(activity_type: 'downloaded', activity_time: 1.week.ago..) }
  scope :downloaded_in_last_month, -> { where(activity_type: 'downloaded', activity_time: 1.month.ago..) }

  scope :approved_in_last_week, -> { where(activity_type: 'approved', activity_time: 1.week.ago..) }
  scope :approved_in_last_month, -> { where(activity_type: 'approved', activity_time: 1.month.ago..) }

  scope :rejected_in_last_week, -> { where(activity_type: 'rejected', activity_time: 1.week.ago..) }
  scope :rejected_in_last_month, -> { where(activity_type: 'rejected', activity_time: 1.month.ago..) }

  def datetime_format_activity
    activity_time.strftime('%d/%m/%Y %I:%M %p')
  end
end
