class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: :user_id

  has_many :wba_selves, foreign_key: :user_id
  has_many :wba_team_members, foreign_key: :user_id

  has_many :crisis_events, foreign_key: :user_id

  def release
    release_date.present? ? release_date.strftime('%d/%m/%Y') : ''
  end

  def active_crisis_events
    crisis_events.where('created_at > ? and closed is ?', 1.hours.ago, false).includes(:crisis_type)
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
