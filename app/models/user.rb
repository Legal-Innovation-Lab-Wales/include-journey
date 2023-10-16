# app/models/user.rb
class User < DeviseRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
        #  :confirmable,
         :lockable, :timeoutable, :trackable

  # General Association for all tenants
  has_many :notes, foreign_key: :user_id, dependent: :delete_all
  has_many :messages, foreign_key: :user_id, dependent: :destroy
  has_many :contacts, foreign_key: :user_id, dependent: :delete_all
  has_many :wellbeing_assessments, foreign_key: :user_id
  has_many :wba_scores, through: :wellbeing_assessments
  has_many :diary_entries, foreign_key: :user_id, dependent: :destroy
  has_many :goal_permissions, foreign_key: :user_id, dependent: :destroy
  has_many :appointments, foreign_key: :user_id, dependent: :delete_all
  has_many :goals, foreign_key: :user_id, dependent: :delete_all
  has_many :user_profile_view_logs, foreign_key: :user_id, dependent: :delete_all
  has_many :user_tags, foreign_key: :user_id, dependent: :delete_all
  has_many :survey_responses, foreign_key: :user_id
  has_many :sessions, foreign_key: :user_id, dependent: :delete_all
  has_many :user_achievements, foreign_key: :user_id, dependent: :delete_all
  has_many :assignments
  has_many :diary_entry_permissions
  has_many :diary_entry_permissions, through: :diary_entries
  has_many :team_members, through: :assignments
  has_many :uploads
  has_many :upload_activity_logs, through: :uploads
  has_many :notifications

  # Wallich Journey Specific Association
  has_one :emergency_contact
  belongs_to :accommodation_type, optional: true
  belongs_to :housing_provider, optional: true
  belongs_to :support_ending_reason, optional: true
  belongs_to :referred_from, optional: true
  belongs_to :priority, optional: true
  belongs_to :wallich_local_authority, optional: true

  before_update :verify_achievements
  before_update :mail_approved_user, if: -> { approved_changed? && approved? }
  before_update :mail_suspended_user, if: -> { suspended_changed? }
  before_update :mail_deleted_user, if: -> { deleted_changed? && deleted? }

  scope :can_be_deleted, -> { where('deleted_at is not null and deleted_at <= ?', Time.now) }
  scope :active_last_week, -> { where('current_sign_in_at >= ?', 1.week.ago) }
  scope :active_last_month, -> { where('current_sign_in_at >= ?', 1.month.ago) }
  scope :deleted, -> { where(deleted: true) }
  scope :approved, -> { where({approved: true, deleted: false}) }
  scope :last_assessed_today, lambda {
    where(':start <= last_assessed_at and last_assessed_at <= :end',
          { start: Time.zone.now.beginning_of_day, end: Time.zone.now.end_of_day })
  }
  scope :not_assessed_today, -> { where.not(id: last_assessed_today) }
  scope :last_wellbeing, lambda {
    joins(:wellbeing_assessments)
      .where('wellbeing_assessments.created_at = (SELECT MAX(wellbeing_assessments.created_at)
      FROM wellbeing_assessments WHERE wellbeing_assessments.user_id = users.id)')
  }

  PRONOUN_OPTIONS = ['', 'He/Him', 'She/Her', 'They/Them', 'Ze (or Zie)', nil].freeze
  SEX_OPTIONS = ['', 'Male', 'Female', 'Prefer not to say', nil].freeze
  GENDER_IDENTITY_OPTIONS = ['', 'Yes', 'No', 'Prefer not to say', nil].freeze
  RELIGION_OPTIONS = [
    '',
    'No religion',
    'Christian',
    'Buddhist',
    'Hindu',
    'Jewish',
    'Muslim',
    'Sikh',
    'Any other religion',
    'Prefer not to say',
    nil
  ].freeze
  ETHNICITY_OPTIONS = [
    '',
    'Prefer not to say',
    'Arab',
    'Asian or Asian British: Bangladeshi',
    'Asian or Asian British: Chinese',
    'Asian or Asian British: Indian',
    'Asian or Asian British: Other',
    'Black or Black British: African',
    'Black or Black British: Carribean',
    'Black or Black British: Other',
    'Mixed: Other',
    'Mixed: White and Asian',
    'Mixed: White and Black African',
    'Mixed: White and Black Carribean',
    'White: Irish',
    'White: Other',
    'White: British/English/Welsh/Scottish/Northern Irish',
    'White: Gypsy/Irish Traveller/Romany',
    'Other Ethnic Group',
    nil
  ].freeze

  validates_presence_of :terms, :first_name, :last_name, :email
  validates_format_of :first_name, with: Rails.application.config.regex_name
  validates_format_of :last_name, with: Rails.application.config.regex_name
  validates_format_of :mobile_number, with: Rails.application.config.regex_telephone
  validates_format_of :email, with: Rails.application.config.regex_email
  validates_format_of :disabilities, with: Rails.application.config.regex_text_field
  validates_format_of :summary_panel, with: Rails.application.config.regex_text_field
  validates_format_of :address, with: Rails.application.config.regex_text_field
  validates :email, uniqueness: { case_sensitive: false }
  validates :terms, acceptance: true
  validates :ethnic_group, inclusion: { in: ETHNICITY_OPTIONS }
  validates :religion, inclusion: { in: RELIGION_OPTIONS }
  validates :sex, inclusion: { in: SEX_OPTIONS }
  validates :gender_identity, inclusion: { in: GENDER_IDENTITY_OPTIONS }
  validates :pronouns, inclusion: { in: PRONOUN_OPTIONS }
  validates :total_upload_size, numericality: { greater_than_or_equal_to: 0 }

  def dob
    date_of_birth.present? ? date_of_birth.strftime('%d/%m/%Y') : ''
  end

  def last_wellbeing_assessment
    wellbeing_assessments.includes(:wba_scores).last
  end

  def wellbeing_assessment_today
    wellbeing_assessments.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order(:id).last
  end

  def wellbeing_assessment_history
    history = { labels: [], datasets: [] }

    wba_scores.includes(:wellbeing_metric)
              .joins(:wellbeing_metric)
              .order(created_at: :desc).each { |score| score.add_to_history(history) }

    wellbeing_assessments.order(created_at: :desc).each { |score| score.add_to_history(history) }

    history
  end

  def mail_admin
    UserMailer.approved(self).deliver_now
  end

  def mail_approved_user
    UserMailer.approved(self).deliver_now
  end

  def mail_suspended_user
    UserMailer.suspended(self).deliver_now
  end

  def mail_rejected_user
    UserMailer.rejected(self).deliver_now
  end

  def mail_deleted_user
    UserMailer.deleted(self).deliver_now
  end

  # Appointments filters
  def future_appointments
    appointments.order(start: :asc).filter(&:future)
  end

  def past_appointments
    appointments.order(start: :asc).filter(&:past)
  end

  def last_month_appointments
    appointments.order(start: :asc).filter(&:last_month)
  end

  def to_csv
    csv_data = [
      id,
      full_name,
      dob,
      sex,
      gender_identity,
      ethnic_group,
      disabilities,
      user_tags.map { |user_tag| user_tag.tag.tag }.join(', ')
    ]

    if ENV['ORGANISATION_NAME'] == 'wallich-journey'
      csv_data << accommodation_type.name&.presence || ''
      csv_data << housing_provider.name&.presence || ''
      csv_data << support_ending_reason.name&.presence || ''
      csv_data << referred_from.name&.presence || ''
      csv_data << priority.name&.presence || ''
      csv_data << wallich_local_authority.name&.presence || ''
    end

    csv_data
  end

  def json
    data = {
      'ID': id,
      'Name': full_name,
      'Date Of Birth': dob,
      'Sex': sex,
      'Gender Identity': gender_identity,
      'Ethnic Group': ethnic_group,
      'Disabilities': disabilities,
      'Tags': user_tags.map { |user_tag| user_tag.tag.tag }.join(', ')
    }

    if ENV['ORGANISATION_NAME'] == 'wallich-journey'
      data['Accommodation Types'] = accommodation_type.name&.presence || ''
      data['Housing Providers'] = housing_provider.name&.presence || ''
      data['Reasons For Ending Support'] = support_ending_reason.name&.presence || ''
      data['Referred From'] = referred_from.name&.presence || ''
      data['Priorities'] = priority.name&.presence || ''
      data['Local Authority'] = wallich_local_authority.name&.presence || ''

    end

    data
  end

  def unapprove
    sessions.destroy_all
    mail_rejected_user
    self.delete
  end

  def destroy
    [notes, contacts, appointments, goals, user_tags].each(&:delete_all)
    [diary_entries, goal_permissions].each(&:destroy_all)

    anonymize
  end

  def verify_achievements
    %w[sessions wellbeing_assessments diary_entries goals_achieved].each do |entities|
      Achievement.all_time.for(entities).check(self) if changed.include?("#{entities}_count")

      if Achievement.this_month.for(entities).present? && changed.include?("#{entities}_this_month_count")
        Achievement.this_month.for(entities).check(self)
      end
    end
  end

  def reset_monthly_counts
    %w[sessions wellbeing_assessments diary_entries goals_achieved].each do |entities|
      update!({ "#{entities}_this_month_count": 0 })
    end
  end

  def assigned_team_member(team_member_id)
    assignments.any? { |tm| tm.team_member_id == team_member_id }
  end

  def remove_goal_permissions(team_member_id)
    permission = goal_permissions.where(team_member_id: team_member_id)
    if permission
      permission.destroy_all
    end
  end

  def remove_diary_entry_permissions(team_member_id)
    permission = diary_entry_permissions.where(team_member_id: team_member_id)
    if permission
      permission.destroy_all
    end
  end

  def remove_team_member(team_member_id)
    return unless assigned_team_member(team_member_id)

    remove_goal_permissions(team_member_id)
    remove_diary_entry_permissions(team_member_id)
    assignments.find_by(team_member_id: team_member_id).destroy!
  end

  def assign_team_member(team_member_id)
    return if assigned_team_member(team_member_id)
    assignments.create!(team_member_id: team_member_id)
  end

  private

  def anonymize
    skip_email_changed_notification!
    update(first_name: 'Deleted', last_name: 'User', email: "deleted-user-#{id}@fake-email.com", mobile_number: Faker::Number.leading_zero_number(digits: 11),
           nomis_id: nil, pnc_no: nil, delius_no: nil, deleted: true)
  end
end
