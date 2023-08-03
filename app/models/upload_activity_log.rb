# app/models/upload_activity_log.rb
class UploadActivityLog < ApplicationRecord
  belongs_to :team_members
  belongs_to :uploads

  validates_presence_of :activity_type, :activity_time
  validates :activity_type, inclusion: { in: %w[created viewed modified downloaded approved rejected] }
end
