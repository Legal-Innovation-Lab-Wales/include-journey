# app/models/upload_activity_log.rb
class UploadActivityLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :upload

  validates_presence_of :activity_type, :activity_time
  validates :activity_type, inclusion: { in: %w[viewed modified downloaded approved rejected] }

  scope :viewed_in_last_week, -> { where(activity_type: 'viewed').where('activity_time >= ?', 1.week.ago) }
  scope :viewed_in_last_month, -> { where(activity_type: 'viewed').where('activity_time >= ?', 1.month.ago) }

  scope :modified_in_last_week, -> { where(activity_type: 'modified').where('activity_time >= ?', 1.week.ago) }
  scope :modified_in_last_month, -> { where(activity_type: 'modified').where('activity_time >= ?', 1.month.ago) }

  scope :downloaded_in_last_week, -> { where(activity_type: 'downloaded').where('activity_time >= ?', 1.week.ago) }
  scope :downloaded_in_last_month, -> { where(activity_type: 'downloaded').where('activity_time >= ?', 1.month.ago) }

  scope :approved_in_last_week, -> { where(activity_type: 'approved').where('activity_time >= ?', 1.week.ago) }
  scope :approved_in_last_month, -> { where(activity_type: 'approved').where('activity_time >= ?', 1.month.ago) }

  scope :rejected_in_last_week, -> { where(activity_type: 'rejected').where('activity_time >= ?', 1.week.ago) }
  scope :rejected_in_last_month, -> { where(activity_type: 'rejected').where('activity_time >= ?', 1.month.ago) }

  def datetime_format_activity
    activity_time.strftime('%d/%m/%Y %I:%M %p')
  end
end
