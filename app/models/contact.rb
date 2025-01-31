class Contact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates :user_id, :name, :description, presence: true
  validates :name, format: {
    with: Rails.application.config.regex_name,
    message: Rails.application.config.name_error,
  }
  validates :description, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :number, format: {
    with: Rails.application.config.regex_telephone,
    message: Rails.application.config.telephone_error,
  }
  validates :email, format: {
    with: Rails.application.config.regex_email,
    message: Rails.application.config.email_error,
  }
end
