# frozen_string_literal: true

# app/models/upload_file.rb
class UploadFile < ApplicationRecord
  belongs_to :upload

  validates_presence_of :data, :content_type
  validates :content_type, inclusion: { in: %w[application/pdf image/jpeg image/png] }

  def encoded_data
    return nil if data.nil?

    Base64.encode64(data)
  end

  def grab_upload_file
    return nil if data.nil?

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % encoded_data).html_safe
  end
end
