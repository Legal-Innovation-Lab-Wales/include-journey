# app/model/contact_log.rb
class ContactLog < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :contact_type
  belongs_to :contact_purpose

  validates_presence_of :contact_type, :user, :start, :end
  validates_format_of :notes, with: Rails.application.config.regex_text_field, on: %i[create update]
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
      'ID': id,
      'Date': created
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
      .merge(team_member.present? ? team_member.json.transform_keys { |key| "Team Member #{key}" } : {})
      .merge(contact_type.present? ? contact_type.json.transform_keys { |key| "contact_type_#{key}" } : {})
  end

  def to_csv
    [id, created] + user.to_csv + (team_member.present? ? team_member.to_csv : [nil, nil]) + contact_type.to_csv
  end
end
