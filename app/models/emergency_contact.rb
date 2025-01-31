# app/model/emergency_contact.rb
class EmergencyContact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates :name, :relationship, :number, presence: true
  validates :name, format: {
    with: Rails.application.config.regex_name,
    message: Rails.application.config.name_error,
  }
  validates :number, format: {
    with: Rails.application.config.regex_telephone,
    message: Rails.application.config.telephone_error,
  }
  validates :relationship, format: {
    with: Rails.application.config.regex_name,
    message: Rails.application.config.name_error,
  }
end
