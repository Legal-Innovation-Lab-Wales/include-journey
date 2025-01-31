# app/model/contact_log.rb
class ContactLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :contact_type
  belongs_to :contact_purpose

  validates :contact_type, :user, :start, :end, presence: true
  validates :notes, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :start, :end, format: {
    with: Rails.application.config.regex_datetime,
    message: Rails.application.config.datetime_error,
  }
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
    return Date.today unless start.present?

    start.strftime('%Y-%m-%d')
  end

  def start_time
    return '12:00' unless start.present?

    start.strftime('%H:%M')
  end

  def end_date
    return Date.today unless self.end.present?

    self.end.strftime('%Y-%m-%d')
  end

  def end_time
    return '12:00' unless self.end.present?

    self.end.strftime('%H:%M')
  end

  def last_month
    start >= DateTime.now - 1.month
  end

  def json
    {
      ID: id,
      'Creation Date': created,
      Notes: notes,
      'Start Date': "#{start_date} #{start_time}",
      'End Date': "#{end_date} #{end_time}",
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
      .merge(team_member.present? ? team_member.json.transform_keys { |key| "Team Member #{key}" } : {})
      .merge(contact_type.present? ? contact_type.json.transform_keys { |key| "contact_type_#{key}" } : {})
      .merge(contact_purpose.present? ? contact_purpose.json.transform_keys { |key| "contact_purpose_#{key}" } : {})
  end

  def to_csv
    [
      id,
      created,
      notes,
      "#{start_date} #{start_time}",
     "#{end_date} #{end_time}",
    ] + user.to_csv + (if team_member.present?
      team_member.to_csv
    else
      [nil, nil]
    end) + contact_type.to_csv + contact_purpose.to_csv
  end
end
