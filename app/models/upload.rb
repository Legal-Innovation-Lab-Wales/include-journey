# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true
  has_one :upload_file, dependent: :destroy

  validates_presence_of :status
  validates :status, inclusion: { in: %w[pending approved] }
  validates :added_by, inclusion: { in: %w[User TeamMember] }

  scope :created_in_last_week, -> { where('uploads.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('uploads.created_at >= ?', 1.month.ago) }
  scope :pdf_files, -> { joins(:upload_file).where(upload_files: { content_type: 'application/pdf' }) }
  scope :images, -> { joins(:upload_file).where.not(upload_files: { content_type: 'application/pdf' }) }
  scope :uploaded_by_teammember, -> { where(added_by: 'TeamMember') }
  scope :uploaded_by_user, -> { where(added_by: 'User') }
  scope :pending, -> { where(status: 'pending') }

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

  def file_size
    if upload_file.data.size < 1.megabyte
      "#{upload_file.data.size / 1024} KB"
    else
      "#{upload_file.data.size / 1_048_576.0} MB"
    end
  end
end
