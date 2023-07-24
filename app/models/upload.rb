# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :uploadable, polymorphic: true
  has_one :upload_file

  validates_presence_of :status
  validates :status, inclusion: { in: %w[pending approved rejected] }

  after_create :approve_if_added_by_team_member

  scope :created_in_last_week, -> { where('uploads.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('uploads.created_at >= ?', 1.month.ago) }
  scope :pdf_files, -> { joins(:upload_file).where(upload_files: { content_type: 'application/pdf' }) }
  scope :images, -> { joins(:upload_file).where.not(upload_files: { content_type: 'application/pdf' }) }
  scope :uploaded_by_teammember, -> { where(uploadable_type: 'TeamMember') }
  scope :uploaded_by_user, -> { where.not(uploadable_type: 'TeamMember') }

  def grab_upload_file
    if upload_file.nil?
      return '<i class="fas fa-image"></i>'.html_safe
    end

    if upload_file.content_type == 'application/pdf'
      'render default pdf image'
    else
      ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % Base64.encode64(upload_file.data)).html_safe
    end
  end

  private

  def approve_if_added_by_team_member
    self.status = 'approved' if uploadable.present? && uploadable.is_a?(TeamMember)
  end
end
