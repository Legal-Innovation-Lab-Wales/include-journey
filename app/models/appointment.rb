# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :user
end
