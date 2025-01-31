# frozen_string_literal: true

# app/models/upload_file.rb
class UploadFile < ApplicationRecord
  belongs_to :upload

  CONTENT_TYPES = ['application/pdf', 'image/jpeg', 'image/png'].freeze

  validates :data, :content_type, :name, presence: true
  validates :content_type, inclusion: {in: CONTENT_TYPES}
  validates :name, format: {
    with: Rails.application.config.regex_file_name,
    message: Rails.application.config.file_name_error,
  }

  def encoded_data
    return nil if data.nil?

    Base64.encode64(data)
  end

  def grab_upload_file
    return nil if data.nil?

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % encoded_data).html_safe
  end

  def file_content_type
    all_content_types = {
      'application/pdf' => 'PDF File',
      'image/jpeg' => 'Image File ( JPEG )',
      'image/png' => 'Image File ( PNG )',
    }

    all_content_types[content_type]
  end
end
