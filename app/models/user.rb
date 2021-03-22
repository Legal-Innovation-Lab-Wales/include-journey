# app/models/user.rb
class User < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :user_id

  has_many :wba_selves, foreign_key: :user_id
  has_many :wba_team_members, foreign_key: :user_id

  has_many :crisis_events, foreign_key: :user_id
  has_many :journal_entries, foreign_key: :user_id

  def release
    release_date.present? ? release_date.strftime('%d/%m/%Y') : 'Unknown Release Date'
  end

  def active_crisis_events
    crisis_events.where('created_at > ? and closed is ?', 1.hours.ago, false).includes(:crisis_type)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_wba_self
    wba_selves.includes(:wba_self_scores).last
  end

  def wba_self_today
    wba_selves.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order(:id).last
  end

  def permissions_required?
    last_journal_entry = journal_entries.includes(:journal_entry_permissions).last

    return unless last_journal_entry.present?

    last_journal_entry.journal_entry_permissions.empty?
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
