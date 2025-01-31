# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :team_member, optional: true

  # Input validation
  validates :where, :who_with, :what, :start, :end, presence: true
  validates :where, :who_with, :what, format: {
    with: Rails.application.config.regex_name,
    message: Rails.application.config.name_error,
  }
  validates :start, :end, format: {
    with: Rails.application.config.regex_datetime,
    message: Rails.application.config.datetime_error,
  }

  scope :future, -> { where('start >= ?', Time.now) }
  scope :past, -> { where('start <= ?', Time.now) }
  scope :last_week, -> { where('start >= ?', 1.week.ago) }
  scope :last_month, -> { where('start >= ?', 1.month.ago) }
  scope :next_week, -> { where('start <= ?', 1.week.from_now) }
  scope :next_fortnight, -> { where('start <= ?', 2.weeks.from_now) }
  scope :user_created, -> { where('team_member_id is null') }
  scope :team_member_created, -> { where.not(team_member_id: nil) }

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
end
