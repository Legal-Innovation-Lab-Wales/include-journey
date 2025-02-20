# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true
  belongs_to :parent_folder, class_name: 'Folder', optional: true
  has_one :upload_file, dependent: :destroy
  has_many :upload_activity_logs
  has_one :notification

  validates :status, presence: true
  validates :status, inclusion: {in: ['pending', 'approved']}
  validates :added_by, inclusion: {in: ['User', 'TeamMember']}
  validates_associated :upload_file
  validates :comment, format: {with: Rails.application.config.regex_text_field,
                               message: Rails.application.config.text_field_error,}

  scope :created_in_last_week, -> { where(uploads: {created_at: 1.week.ago..}) }
  scope :created_in_last_month, -> { where(uploads: {created_at: 1.month.ago..}) }
  scope :pdf_files, -> { joins(:upload_file).where(upload_files: {content_type: 'application/pdf'}) }
  scope :images, -> { joins(:upload_file).where.not(upload_files: {content_type: 'application/pdf'}) }
  scope :uploaded_by_teammember, -> { where(added_by: 'TeamMember') }
  scope :uploaded_by_user, -> { where(added_by: 'User') }
  scope :pending, -> { where(status: 'pending') }

  def grab_upload_file
    return '<i class="fas fa-image"></i>'.html_safe if upload_file.nil?

    if upload_file.content_type == 'application/pdf'
      'render default pdf image'
    else
      upload_file.grab_upload_file
    end
  end

  def file_size
    if upload_file.data.size < 1.megabyte
      "#{format('%.2f', upload_file.data.size / 1_024.0)} KiB"
    else
      "#{format('%.2f', upload_file.data.size / 1_048_576.0)} MiB"
    end
  end
end
