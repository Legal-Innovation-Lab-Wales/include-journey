class Contact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates_presence_of :user_id, :name, :description
  validates_format_of :name, with: Rails.application.config.regex_name,
                             message: Rails.application.config.name_error
  validates_format_of :description, with: Rails.application.config.regex_text_field,
                                    message: Rails.application.config.text_field_error
  validates_format_of :number, with: Rails.application.config.regex_telephone,
                               message: Rails.application.config.telephone_error
  validates_format_of :email, with: Rails.application.config.regex_email,
                              message: Rails.application.config.email_error
end
