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

  def get_last_sign_in
    self.last_sign_in_at.present? ? self.last_sign_in_at.strftime("%d/%m/%Y %I:%M %p") : ''
  end

  def get_release_date
    self.release_date.present? ? self.release_date.strftime("%d/%m/%Y") : ''
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
