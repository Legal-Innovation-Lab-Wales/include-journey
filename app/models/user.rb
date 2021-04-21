# app/models/user.rb
class User < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :user_id
  has_many :contacts, foreign_key: :user_id

  has_many :wellbeing_assessments, foreign_key: :user_id
  has_many :wba_scores, through: :wellbeing_assessments

  has_many :crisis_events, foreign_key: :user_id
  has_many :journal_entries, foreign_key: :user_id

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

    wba_scores.includes(:wellbeing_metric).order(created_at: :desc).each { |score| score.add_to_history(history) }

    history
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
