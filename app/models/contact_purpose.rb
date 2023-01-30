# app/models/contact_purpose.rb
class ContactPurpose < ApplicationRecord
  validates_presence_of :name
end
