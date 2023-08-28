# app/model/emergency_contact.rb
class EmergencyContact < ApplicationRecord
  belongs_to :user
end
