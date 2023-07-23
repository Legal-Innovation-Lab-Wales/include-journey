# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :uploadable, polymorphic: true
  has_one :upload_file

  validates_presence_of :status
  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_create :approve_if_added_by_team_member

  def grab_upload_file
    if upload_files.first.nil?
      return '<i class="fas fa-image"></i>'.html_safe
    end

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % Base64.encode64(upload_files.first.data)).html_safe
  end

  private

  def approve_if_added_by_team_member
    self.status = 'approved' if uploadable.present? && uploadable.is_a?(TeamMember)
  end
end
