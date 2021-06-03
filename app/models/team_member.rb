# app/models/team_member.rb
class TeamMember < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :team_member_id
  has_many :crisis_types, foreign_key: :team_member_id
  has_many :crisis_notes, foreign_key: :team_member_id
  has_many :wellbeing_metrics, foreign_key: :team_member_id
  has_many :wellbeing_assessments, foreign_key: :team_member_id
  has_many :crisis_types, foreign_key: :team_member_id
  has_many :crisis_events, foreign_key: 'closed_by'
  has_many :crisis_notes, foreign_key: :team_member_id
  has_many :journal_entry_permissions, foreign_key: :team_member_id
  has_many :journal_entry_view_logs, foreign_key: :team_member_id
  has_many :viewed_journal_entries, through: :journal_entry_view_logs, source: :journal_entry
  has_many :journal_entries, through: :journal_entry_permissions
  has_many :user_profile_view_logs, foreign_key: :team_member_id
  has_many :user_pins, foreign_key: :team_member_id
  has_many :pinned_users, through: :user_pins, source: :user
  has_many :wellbeing_services
  has_many :created_tags, foreign_key: :team_member_id, class_name: 'Tag'
  has_many :assigned_tags, through: :user_tags, source: :tag

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :admins, -> { where(admin: true) }

  def unread_journal_entries(user)
    (journal_entries.where(user: user) - viewed_journal_entries.where(user: user)).count
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
