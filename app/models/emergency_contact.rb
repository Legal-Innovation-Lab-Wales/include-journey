# app/model/emergency_contact.rb
class EmergencyContact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates_presence_of :name, :relationship, :number
  validates_format_of :name, with: Rails.application.config.regex_name,
                             message: Rails.application.config.name_error
  validates_format_of :number, with: Rails.application.config.regex_telephone,
                               message: Rails.application.config.telephone_error
  validates_format_of :relationship, with: Rails.application.config.regex_name,
                                     message: Rails.application.config.name_error
end
