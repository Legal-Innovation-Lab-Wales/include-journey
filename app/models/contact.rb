class Contact < ApplicationRecord
  belongs_to :user

  # Add input validations
  validates_presence_of :user_id, :name, :description
  validates_format_of :name, with: /\A[a-zA-Z0-9,. ]*\z/, on: :create
  validates_format_of :description, with: /\A[a-zA-Z0-9,. ]*\z/, on: :create
  validates_format_of :number, with: /\A[0-9]*\z/, on: :create
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
