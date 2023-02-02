class Contact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates_presence_of :user_id, :name, :description
  validates_format_of :name, with: Rails.application.config.regex_name
  validates_format_of :description, with: Rails.application.config.regex_text_field
  validates_format_of :number, with: Rails.application.config.regex_telephone
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
