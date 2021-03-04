class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :notes, foreign_key: true

  has_many :wba_selves, foreign_key: true
  has_many :wba_team_members, foreign_key: true

  has_many :crisis_events, foreign_key: true

  private

  # validations
  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
end
