# app/models/upload_activity_log.rb
class UploadActivityLog < ApplicationRecord
  belongs_to :team_members
  belongs_to :uploads
end
