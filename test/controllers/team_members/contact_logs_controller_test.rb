# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class ContactLogsControllerTest < ControllerTest
    def setup
      super
      travel_to Time.zone.parse('2021-01-20 12:00')
    end

    def valid_params
      @contact_type = contact_types(:other)
      @contact_purpose = contact_purposes(:phone_use)
      @start = Time.zone.parse('2021-01-19 14:00')
      @end = Time.zone.parse('2021-01-19 14:45')

      {
        user_id: @user.id,
        contact_type_id: @contact_type.id,
        contact_purpose_id: @contact_purpose.id,
        start: @start,
        end: @end,
      }
    end

    test 'team member can view recent contact logs for themselves' do
      barbara = team_members :barbara
      
      sign_in barbara
      get recent_contact_logs_path

      # Recent logs for Barbara
      assert_match 'Talking about the app', @response.body
      assert_match 'Talking about mental health', @response.body
      # Not included as it is not recent
      refute_match 'Talking about food', @response.body
      # Not included as it's not for Barbara
      refute_match 'Talking about money', @response.body
    end

    test 'team member can view recent contact logs for another team member' do
      alan, barbara = team_members :alan, :barbara
      
      sign_in barbara
      get recent_team_member_contact_logs_path(alan)

      # Recent log for Alan
      assert_match 'Talking about money', @response.body
      # Logs for Barbara
      refute_match 'Talking about the app', @response.body
      refute_match 'Talking about mental health', @response.body
      refute_match 'Talking about food', @response.body
    end

    test 'team member can view recent contact logs for a user' do
      barbara = team_members :barbara
      alice = users :alice
      
      sign_in barbara
      get recent_user_contact_logs_path(alice)

      # Recent logs for Alice
      assert_match 'Talking about money', @response.body
      assert_match 'Talking about the app', @response.body
      # Not included as it is not recent
      refute_match 'Talking about food', @response.body
      # Not included as it is not for Alice
      refute_match 'Talking about mental health', @response.body
    end

    test 'ordinary user cannot view recent contact logs for a team member' do
      barbara = team_members :barbara
      
      sign_in @user
      begin
        get recent_team_member_contact_logs_path(barbara)
      rescue ActionController::RoutingError
        # do nothing
      end

      refute_match 'Talking about money', @response.body
      refute_match 'Talking about the app', @response.body
      refute_match 'Talking about mental health', @response.body
      refute_match 'Talking about food', @response.body
    end

    test 'ordinary user cannot view recent contact logs for themselves' do
      sign_in @user
      begin
        get recent_user_contact_logs_path(@user)
      rescue ActionController::RoutingError
        # do nothing
      end

      refute_match 'Talking about money', @response.body
      refute_match 'Talking about the app', @response.body
      refute_match 'Talking about mental health', @response.body
      refute_match 'Talking about food', @response.body
    end

    test 'team member can create a contact log' do
      sign_in @team_member
      assert_difference 'ContactLog.count', 1 do
        post contact_logs_path, params: {contact_log: valid_params.merge(notes: 'Had a nice meeting')}
      end

      contact_log = ContactLog.where(start: @start).first
      assert_equal @team_member, contact_log.team_member
      assert_equal @user, contact_log.user
      assert_equal @contact_type, contact_log.contact_type
      assert_equal @contact_purpose, contact_log.contact_purpose
      assert_equal 'Had a nice meeting', contact_log.notes
      assert_equal @start, contact_log.start
      assert_equal @end, contact_log.end
    end

    test 'contact log with missing params is not created' do
      sign_in @team_member
      each_missing_param do |params|
        assert_no_difference 'ContactLog.count' do
          post contact_logs_path, params: {contact_log: params}
        rescue TypeError
          # do nothing
        end
      end
    end

    test 'ordinary user cannot create a contact log' do
      sign_in @user
      assert_no_difference 'ContactLog.count' do
        post contact_logs_path, params: {contact_log: valid_params.merge(notes: 'Had a nice meeting')}
      rescue ActionController::RoutingError
        # do nothing
      end
    end

    test 'team member can update their own contact log' do
      contact_log = contact_logs :one
      assert_equal @team_member, contact_log.team_member
  
      sign_in @team_member
      assert_no_difference 'ContactLog.count' do
        put contact_log_path(contact_log), params: {contact_log: valid_params.merge(notes: 'Had a nice meeting')}
      end
  
      contact_log.reload
      assert_equal @team_member, contact_log.team_member
      assert_equal @user, contact_log.user
      assert_equal @contact_type, contact_log.contact_type
      assert_equal @contact_purpose, contact_log.contact_purpose
      assert_equal 'Had a nice meeting', contact_log.notes
      assert_equal @start, contact_log.start
      assert_equal @end, contact_log.end
    end
  
    test 'team member cannot update a contact log belonging to another team member' do
      contact_log = contact_logs :three
      owning_team_member = contact_log.team_member
      assert_not_equal owning_team_member, @team_member
  
      sign_in @team_member
      assert_no_difference 'ContactLog.count' do
        put contact_log_path(contact_log), params: {contact_log: valid_params.merge(notes: 'Had a nice meeting')}
      end
  
      contact_log.reload
      assert_equal owning_team_member, contact_log.team_member
      assert_not_equal @contact_type, contact_log.contact_type
      assert_not_equal @contact_purpose, contact_log.contact_purpose
      assert_not_equal 'Had a nice meeting', contact_log.notes
      assert_not_equal @start, contact_log.start
      assert_not_equal @end, contact_log.end
    end

    test 'ordinary user cannot update a contact log' do
      contact_log = contact_logs :one
  
      sign_in @user
      assert_no_difference 'ContactLog.count' do
        put contact_log_path(contact_log), params: {contact_log: valid_params.merge(notes: 'Had a nice meeting')}
      rescue ActionController::RoutingError
        # do nothing
      end
  
      contact_log.reload
      assert_not_equal @contact_type, contact_log.contact_type
      assert_not_equal @contact_purpose, contact_log.contact_purpose
      assert_not_equal 'Had a nice meeting', contact_log.notes
      assert_not_equal @start, contact_log.start
      assert_not_equal @end, contact_log.end
    end

    test 'team member can destroy their own contact log' do
      contact_log = contact_logs :one
      assert_equal @team_member, contact_log.team_member

      sign_in @team_member
      assert_difference 'ContactLog.count', -1 do
        delete contact_log_path(contact_log)
      end

      assert_destroyed contact_log
    end

    test 'team member cannot destroy a contact log belonging to another team member' do
      contact_log = contact_logs :three
      assert_not_equal @team_member, contact_log.team_member

      sign_in @team_member
      assert_no_difference 'ContactLog.count' do
        delete contact_log_path(contact_log)
      end

      contact_log.reload
    end

    test 'ordinary user cannot destroy a contact log' do
      contact_log = contact_logs :one

      sign_in @user
      assert_no_difference 'ContactLog.count' do
        delete contact_log_path(contact_log)
      rescue ActionController::RoutingError
        # do nothing
      end

      contact_log.reload
    end
  end
end
