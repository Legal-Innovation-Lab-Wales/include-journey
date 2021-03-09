class TeamMember < ApplicationRecord
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

  def get_last_sign_in
    self.last_sign_in_at.present? ? self.last_sign_in_at.strftime("%d/%m/%Y %I:%M %p") : ''
  end

  def get_current_sign_in
    self.current_sign_in_at.present? ? self.current_sign_in_at.strftime("%d/%m/%Y %I:%M %p") : ''
  end

  def get_created_at
    self.created_at.strftime("%d/%m/%Y %I:%M %p")
  end

  def last_update
    self.updated_at.strftime("%d/%m/%Y %I:%M %p")
  end

  private

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :mobile_number,
                        :email,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
end
