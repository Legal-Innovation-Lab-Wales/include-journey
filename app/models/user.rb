# app/models/user.rb
class User < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :user_id, dependent: :delete_all
  has_many :contacts, foreign_key: :user_id, dependent: :delete_all
  has_many :wellbeing_assessments, foreign_key: :user_id, dependent: :destroy
  has_many :wba_scores, through: :wellbeing_assessments
  has_many :crisis_events, foreign_key: :user_id, dependent: :destroy
  has_many :journal_entries, foreign_key: :user_id, dependent: :destroy
  has_many :appointments, foreign_key: :user_id, dependent: :delete_all
  has_many :goals, foreign_key: :user_id, dependent: :delete_all
  has_many :user_profile_view_logs, foreign_key: :user_id, dependent: :delete_all
  has_many :user_tags, foreign_key: :user_id, dependent: :delete_all

  scope :can_be_deleted, -> { where('deletion_date is not null and deletion_date <= ?', Time.now) }
  scope :active_last_week, -> { where('current_sign_in_at >= ?', 1.week.ago) }
  scope :active_last_month, -> { where('current_sign_in_at >= ?', 1.month.ago) }

  def release
    release_date.present? ? release_date.strftime('%d/%m/%Y') : 'Unknown Release Date'
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

    wellbeing_assessments.order(created_at: :desc).each { |score| score.add_to_history(history) }

    wba_scores.includes(:wellbeing_metric)
              .joins(:wellbeing_metric)
              .order(created_at: :desc).each { |score| score.add_to_history(history) }

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

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :mobile_number,
                        :email,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
end
