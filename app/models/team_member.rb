# app/models/team_member.rb
class TeamMember < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :team_member_id
  has_many :wellbeing_metrics, foreign_key: :team_member_id
  has_many :wellbeing_assessments, foreign_key: :team_member_id
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
  has_many :contact_logs, foreign_key: :team_member_id, dependent: :delete_all

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :admins, -> { where(admin: true) }

  def unread_journal_entries(user)
    (journal_entries.where(user: user) - viewed_journal_entries.where(user: user)).count
  end

  def to_csv
    [id, full_name]
  end

  def json
    {
      'ID': id,
      'Name': full_name
    }
  end

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :mobile_number,
                        :email,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
  validates_format_of :first_name, :last_name, with: Rails.application.config.regex_name,
                                               message: Rails.application.config.name_error
  validates_format_of :mobile_number, with: Rails.application.config.regex_telephone,
                                      message: Rails.application.config.telephone_error
  validates_format_of :email, with: Rails.application.config.regex_email,
                              message: Rails.application.config.email_error
end
