# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :user

  def time_on_date
    start.strftime("%I:%M%p on %a #{start.day.ordinalize} %B")
  end

  def duration
    duration = self.end - start

    "%02d:%02d:%02d" % [duration / 3600, duration / 60 % 60, duration % 60]
  end
end
