# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  def time_on_date
    start.strftime("%I:%M%p on %a #{start.day.ordinalize} %B")
  end

  def date
    start.strftime("%a #{start.day.ordinalize} %B")
  end

  def start_date
    return Date.tomorrow unless start.present?

    start.strftime('%Y-%m-%d')
  end

  def start_time
    return '12:00' unless start.present?

    start.strftime('%H:%M')
  end

  def end_date
    return Date.tomorrow unless self.end.present?

    self.end.strftime('%Y-%m-%d')
  end

  def end_time
    return '12:00' unless self.end.present?

    self.end.strftime('%H:%M')
  end

  def past
    start <= DateTime.now
  end

  def future
    start >= DateTime.now
  end

  def last_month
    start >= DateTime.now - 1.month
  end

  validates_presence_of :where, :who_with, :what, :start, :end
end
