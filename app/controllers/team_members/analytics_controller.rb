module TeamMembers
  # app/controllers/team_members/analytics_controller.rb
  class AnalyticsController < TeamMembersApplicationController
    before_action :initialize_params, only: :index
    before_action :check_users, :find_filters, :set_breadcrumbs, :update_resource
    include Exportable

    def export; end

    def base_path
      'analytics'
    end

    def csv_headers
      if params[:data] == 'Wellbeing Assessments'
        ['ID', 'Date', 'User ID', 'User Name', 'User Date Of Birth', 'User Release Date', 'User Sex',
         'User Gender Identity', 'User Ethnic Group', 'User Disabilities', 'User Tags', 'Team Member ID',
         'Team Member Name'] + WellbeingMetric.all.order(:id).map(&:name)
      elsif params[:data] == 'Contact Logs'
        ['ID', 'Creation Date','Notes','Start Date','End Date', 'User ID', 'User Name', 'User Date Of Birth', 'User Release Date', 'User Sex',
         'User Gender Identity', 'User Ethnic Group', 'User Disabilities', 'User Tags', 'Team Member ID', 'Team Member Name', 'Contact Type ID', 'Contact Type','Contact Color', 'Contact Purpose']
      else
        ['ID', 'Date', 'User ID', 'User Name', 'User Date Of Birth', 'User Release Date', 'User Sex',
         'User Gender Identity', 'User Ethnic Group', 'User Disabilities', 'User Tags', 'Feeling', 'Entry']
      end
    end

    def index
      render 'index'
    end

    def update_search
      render 'index'
    end

    def resources
      @resource
    end

    def search
      @resource
    end

    private

    def update_resource
      base_resources

      case params[:data]
      when 'Wellbeing Assessments'
        table = 'wellbeing_assessments'
      when 'Contact Logs'
        table = 'contact_logs'
      else
        table = 'diary_entries'
      end
      
      @resource = @resource
                  .where("#{table}.created_at > ?", convert_date(params['date_from'], true))
                  .where("#{table}.created_at < ?", convert_date(params['date_to'], false))

      apply_filters
      @resource = @resource.sort_by(&:created_at)
      @scores = params[:data] === 'Contact Logs' ? ContactType.all : WellbeingScoreValue.order(id: :asc)
      @labels = @scores.pluck(:name)
      @colours = @scores.pluck(:color)
    end

    # rubocop:disable Metrics/LineLength
    # rubocop:disable Metrics/AbcSize
    def base_resources
      case params[:data]
      when 'Wellbeing Assessments'
        wellbeing_data
      when 'Contact Logs'
        contact_log_data
      else
        diary_data
      end
    end

    def wellbeing_data
      if params[:author] != 'Anyone'
        if params[:author] == 'User'
          @resource = WellbeingAssessment.all.where(team_member_id: nil)
        else
          @resource = params[:author] == 'Staff' ? WellbeingAssessment.all.where.not(team_member_id: nil) : TeamMember.find_by(email:params[:member]).wellbeing_assessments
        end
      else
        @resource = WellbeingAssessment.all
      end
    end

    def diary_data
      if current_team_member.admin?
        @resource = params[:member] != 'All' ? TeamMember.find_by(email: params[:member]).diary_entries : DiaryEntry.all
      else
        @resource = current_team_member.diary_entries
      end
    end

    def contact_log_data
      if current_team_member.admin?
        @resource = params[:member] != 'All' ? TeamMember.find_by(email: params[:member]).contact_logs : ContactLog.all
      else
        @resource = current_team_member.contact_logs
      end
    end

    def apply_filters
      @resource = params['sex'].present? ? @resource.joins(:user).where(build_query('users', 'sex', params['sex'], @sexes)) : @resource
      @resource = params['pronoun'].present? ? @resource.joins(:user).where(build_query('users', 'pronouns', params['pronoun'], @pronouns)) : @resource
      @resource = params['ethnicity'].present? ? @resource.joins(:user).where(build_query('users', 'ethnic_group', params['ethnicity'], @ethnic_groups)) : @resource
      @resource = params['religion'].present? ? @resource.joins(:user).where(build_query('users', 'religion', params['religion'], @religions)) : @resource
      @resource = params['age'].present? ? @resource.joins(:user).where(build_age_query(params['age'], @ages)) : @resource
      return unless params['tag'].present?

      tags = UserTag.all.joins(:tag).where(build_query('tags', 'tag', params['tag'], @tags))
      users = User.all.joins(:user_tags).merge(tags)
      @resource = @resource.joins(:user).merge(users).order_by('Date')
    end
    # rubocop:enable Metrics/LineLength

    def find_filters
      @ages = ['Under 22', '23-30', '31-36', '37-45', '46-55', '56-69', '70 and Over']
      @sexes = User.distinct.pluck(:sex).reject!(&:nil?)
      @pronouns = User.distinct.pluck(:pronouns).reject!(&:nil?)
      @ethnic_groups = User.distinct.pluck(:ethnic_group).reject!(&:nil?)
      @religions = User.distinct.pluck(:religion).reject!(&:nil?)
      @team_member_emails = TeamMember.distinct.pluck(:email)
      @tags = Tag.distinct.pluck(:tag)
    end

    def age_filter(field, age_range)
      age_range = age_range.gsub('and Over', '-200').gsub('Under', '?-')
      ages = age_range.split('-', 2)
      ages[0] = numeric?(ages[0]) ? ages[0].to_i.years.ago : Date.today
      ages[1] = numeric?(ages[1]) ? ages[1].to_i.years.ago : 200.years.ago

      "#{field} < '#{ages[0]}' AND #{field} > '#{ages[1]}'"
    end
    # rubocop: enable Metrics/AbcSize

    def build_query(table, attribute, parameters, values)
      res = ''
      values.each do |val|
        if parameters.include? val
          res += res == '' ? '' : ' OR '
          res += "#{table}.#{attribute} ='#{val.gsub("'", "''")}'"
        end
      end
      res
    end

    def build_age_query(parameters, values)
      res = ''
      values.each do |val|
        if parameters.include? val
          res += res == '' ? '' : ' OR '
          res += age_filter('users.date_of_birth', val)
        end
      end
      res
    end

    def numeric?(string)
      true if Float(string) rescue false
    end

    def convert_date(date, use_earliest_date)
      if date != '' && !date.nil?
        date.to_datetime
      else
        use_earliest_date ? Time.at(0).to_datetime : Date.today
      end
    end

    def initialize_params
      params['data'] = 'Diary Entries'
      params['display'] = 'Pie Chart'
      params['date_to'] = Date.today
      params['date_from'] = Date.today - 1.month
      params['member'] = current_team_member.email
    end

    def set_breadcrumbs
      add_breadcrumb('Analytics', nil, 'fas fa-chart-line')
    end

    def check_users
      return unless User.all.empty?

      redirect_back(fallback_location: root_path, alert: 'No Users')
    end

    def collection_to_json(collection)
      @array = []
      collection.each do |entry|
        @array.append(entry.json)
      end
      @array.to_json
    end
    helper_method :collection_to_json
  end
end
