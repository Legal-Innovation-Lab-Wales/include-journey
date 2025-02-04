# frozen_string_literal: true

class AddUploadToNotification < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :upload, foreign_key: true
  end
end
