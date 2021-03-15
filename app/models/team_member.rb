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
  has_many :wba_team_members, foreign_key: :team_member_id

  has_many :wba_self_permissions, foreign_key: :team_member_id
  has_many :wba_self_view_logs, foreign_key: :team_member_id

  has_many :crisis_types, foreign_key: :team_member_id
  has_many :crisis_events, foreign_key: 'closed_by'
  has_many :crisis_notes, foreign_key: :team_member_id

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :mobile_number,
                        :email,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
end
