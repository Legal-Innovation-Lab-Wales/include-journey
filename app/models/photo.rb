# frozen_string_literal: true

# app/models/photo.rb
class Photo < ApplicationRecord
  belongs_to :upload

  validates_presence_of :data

  def encoded_data
    return nil if data.nil?

    Base64.encode64(data)
  end

  def grab_photo
    return nil if data.nil?

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % encoded_data).html_safe
  end
end
