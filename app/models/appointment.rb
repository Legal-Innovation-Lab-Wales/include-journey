# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :user

  def time_on_date
    start.strftime("%I:%M%p on %a #{start.day.ordinalize} %B")
  end
end
