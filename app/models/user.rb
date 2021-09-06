# app/models/user.rb
class User < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :user_id, dependent: :delete_all
  has_many :contacts, foreign_key: :user_id, dependent: :delete_all
  has_many :wellbeing_assessments, foreign_key: :user_id
  has_many :wba_scores, through: :wellbeing_assessments
  has_many :crisis_events, foreign_key: :user_id, dependent: :destroy
  has_many :journal_entries, foreign_key: :user_id, dependent: :destroy
  has_many :appointments, foreign_key: :user_id, dependent: :delete_all
  has_many :goals, foreign_key: :user_id, dependent: :delete_all
  has_many :user_profile_view_logs, foreign_key: :user_id, dependent: :delete_all
  has_many :user_tags, foreign_key: :user_id, dependent: :delete_all
  has_many :survey_responses, foreign_key: :user_id
  has_many :sessions, foreign_key: :user_id, dependent: :delete_all
  has_many :user_achievements, foreign_key: :user_id, dependent: :delete_all

  before_update :verify_achievements

  scope :can_be_deleted, -> { where('deleted_at is not null and deleted_at <= ?', Time.now) }
  scope :active_last_week, -> { where('current_sign_in_at >= ?', 1.week.ago) }
  scope :active_last_month, -> { where('current_sign_in_at >= ?', 1.month.ago) }
  scope :deleted, -> { where(deleted: true) }
  scope :last_assessed_today, lambda {
    where(':start <= last_assessed_at and last_assessed_at <= :end',
          { start: Time.zone.now.beginning_of_day, end: Time.zone.now.end_of_day })
  }
  scope :not_assessed_today, -> { where.not(id: last_assessed_today) }

  validates_presence_of :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true


  def release_date
    released_at.present? ? released_at.strftime('%d/%m/%Y') : ''
  end

  def dob
    date_of_birth.present? ? date_of_birth.strftime('%d/%m/%Y') : ''
  end

  def active_crisis_events
    crisis_events.where('created_at > ? and closed is ?', 1.hours.ago, false).includes(:crisis_type)
  end

  def last_wellbeing_assessment
    wellbeing_assessments.includes(:wba_scores).last
  end

  def wellbeing_assessment_today
    wellbeing_assessments.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order(:id).last
  end

  def wellbeing_assessment_history
    history = { labels: [], datasets: [] }

    wba_scores.includes(:wellbeing_metric)
              .joins(:wellbeing_metric)
              .order(created_at: :desc).each { |score| score.add_to_history(history) }

    wellbeing_assessments.order(created_at: :desc).each { |score| score.add_to_history(history) }

    history
  end

  # Appointments filters
  def future_appointments
    appointments.order(start: :asc).filter(&:future)
  end

  def past_appointments
    appointments.order(start: :asc).filter(&:past)
  end

  def last_month_appointments
    appointments.order(start: :asc).filter(&:last_month)
  end

  # rubocop:disable Metrics/MethodLength
  def to_csv
    [
      id,
      full_name,
      dob,
      released_at,
      sex,
      gender_identity,
      ethnic_group,
      disabilities,
      user_tags.map { |user_tag| user_tag.tag.tag }.join(', ')
    ]
  end

  def json
    {
      'ID': id,
      'Name': full_name,
      'Date Of Birth': dob,
      'Release Date': released_at,
      'Sex': sex,
      'Gender Identity': gender_identity,
      'Ethnic Group': ethnic_group,
      'Disabilities': disabilities,
      'Tags': user_tags.map { |user_tag| user_tag.tag.tag }.join(', ')
    }
  end
  # rubocop:enable Metrics/MethodLength

  def destroy
    [notes, contacts, appointments, goals, user_tags].each(&:delete_all)
    [journal_entries, crisis_events].each(&:destroy_all)

    anonymize
  end

  def verify_achievements
    %w[sessions wellbeing_assessments journal_entries goals_achieved].each do |entities|
      Achievement.all_time.for(entities).check(self) if changed.include?("#{entities}_count")
      Achievement.this_month.for(entities).check(self) if changed.include?("#{entities}_this_month_count")
    end
  end

  private

  def anonymize
    skip_reconfirmation!
    update(first_name: 'Deleted', last_name: 'User', email: "deleted-user-#{id}@fake-email.com", mobile_number: nil,
           nomis_id: nil, pnc_no: nil, delius_no: nil, deleted: true)
  end
end
