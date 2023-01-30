# app/model/contact_log.rb
class ContactLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :contact_type

  validates_presence_of :contact_type, :user, :start, :end
  scope :recent, -> { where('start >= ?', 1.month.ago) }
  scope :past, -> { where('start < ?', 1.month.ago) }
  scope :last_week, -> { where('start >= ?', 1.week.ago) }
  scope :last_month, -> { where('start >= ?', 1.month.ago) }

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

  def last_month
    start >= DateTime.now - 1.month
  end
end
