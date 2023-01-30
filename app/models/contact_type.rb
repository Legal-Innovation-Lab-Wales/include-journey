# app/models/contact_type.rb
class ContactType < ApplicationRecord
  validates_presence_of :name
end
