# app/models/team_member.rb
class TeamMember < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         # options for two factor authentication
         :two_factor_authenticatable, :two_factor_backupable,
         otp_backup_code_length: 10, otp_number_of_backup_codes: 10,
         otp_secret_encryption_key: ENV['MFA_OTP_SECRET_KEY']

  has_many :notes, foreign_key: :team_member_id
  has_many :messages, foreign_key: :team_member_id, dependent: :destroy
  has_many :wellbeing_metrics, foreign_key: :team_member_id
  has_many :wellbeing_assessments, foreign_key: :team_member_id
  has_many :diary_entry_permissions, foreign_key: :team_member_id
  has_many :diary_entry_view_logs, foreign_key: :team_member_id
  has_many :viewed_diary_entries, through: :diary_entry_view_logs, source: :diary_entry
  has_many :diary_entries, through: :diary_entry_permissions
  has_many :user_profile_view_logs, foreign_key: :team_member_id
  has_many :user_pins, foreign_key: :team_member_id
  has_many :pinned_users, through: :user_pins, source: :user
  has_many :wellbeing_services
  has_many :created_tags, foreign_key: :team_member_id, class_name: 'Tag'
  has_many :assigned_tags, through: :user_tags, source: :tag
  has_many :contact_logs, foreign_key: :team_member_id, dependent: :delete_all
  has_many :assignments
  has_many :users, through: :assignments
  has_many :notifications
  has_many :uploads
  has_many :upload_activity_logs
  has_many :folders
  has_one :team_member_notification_frequency

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :admins, -> { where(admin: true) }

  # validations
  validates_presence_of :first_name, :last_name, :mobile_number, :email, :terms
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
  validates :total_upload_size, numericality: { greater_than_or_equal_to: 0 }
  validates_format_of :first_name, :last_name, with: Rails.application.config.regex_name,
                                               message: Rails.application.config.name_error
  validates_format_of :mobile_number, with: Rails.application.config.regex_telephone,
                                      message: Rails.application.config.telephone_error
  validates_format_of :email, with: Rails.application.config.regex_email,
                              message: Rails.application.config.email_error

  def unread_diary_entries(user)
    (diary_entries.where(user: user) - viewed_diary_entries.where(user: user)).count
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

  # Two factor authentication methods begins here -->
  # Generate an OTP secret it it does not already exist
  def generate_two_factor_secret_if_missing!
    return unless otp_secret.nil?

    update!(otp_secret: TeamMember.generate_otp_secret)
  end

  # Ensure that the team member is prompted for their OTP when they login
  def enable_two_factor!
    update!(otp_required_for_login: true)
  end

  # URI for OTP two-factor QR code
  def two_factor_qr_code_uri
    issuer = ENV['MFA_ISSUER_NAME']
    label = [issuer, email].join(':')

    otp_provisioning_uri(label, issuer: issuer)
  end

  # Determine if backup codes have been generated
  def two_factor_backup_codes_generated?
    otp_backup_codes.present?
  end

  # Ensure team members are able to disable the use of OTP-based two-factor
  def disable_two_factor!
    update!(
      otp_required_for_login: false,
      otp_secret: nil,
      otp_backup_codes: nil
    )
  end

  # Determine if user has two-factor authentication enabled
  def two_factor_enabled?
    otp_required_for_login
  end
end
