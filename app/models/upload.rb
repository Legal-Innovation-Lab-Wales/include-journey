# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :uploadable, polymorphic: true
  has_many :upload_files

  validates_presence_of :status, :added_by
  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_create :approve_if_added_by_team_member

  private

  def approve_if_added_by_team_member
    self.status = 'approved' if uploadable.present? && uploadable.is_a?(TeamMember)
  end

  def grab_photo
    if photos.first.nil?
      return '<i class="fas fa-image"></i>'.html_safe
    end

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % Base64.encode64(photos.first.data)).html_safe
  end
end
