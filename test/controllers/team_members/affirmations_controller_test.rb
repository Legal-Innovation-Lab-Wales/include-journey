# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class AffirmationsControllerTest < ControllerTest
    def valid_params
      {
        text: 'You got this!',
        scheduled_date: '2021-05-05',
      }
    end

    test 'team member can view affirmations index' do
      sign_in @team_member
      get affirmations_path

      assert_response :success
    end

    test 'team member can create an affirmation' do
      sign_in @team_member
      assert_difference 'Affirmation.count', 1 do
        post affirmations_path, params: {affirmation: valid_params}
      end

      affirmation = Affirmation.where(text: 'You got this!').first
      assert_equal @team_member, affirmation.team_member
      assert_equal Date.new(2021, 5, 5), affirmation.scheduled_date
    end

    test 'affirmation with missing params is not created' do
      sign_in @team_member
      each_missing_param do |params|
        assert_no_difference 'Affirmation.count' do
          post affirmations_path, params: {affirmation: params}
        end
      end
    end

    test 'ordinary user cannot create an affirmation' do
      sign_in @user
      assert_no_difference 'Affirmation.count' do
        post affirmations_path, params: {affirmation: valid_params}
      rescue ActionController::RoutingError
        # do nothing
      end
    end

    test 'team member can update an affirmation' do
      affirmation = affirmations :one

      sign_in @team_member
      assert_no_difference 'Affirmation.count' do
        put affirmation_path(affirmation), params: {affirmation: valid_params}
      end

      affirmation.reload
      assert_equal @team_member, affirmation.team_member
      assert_equal 'You got this!', affirmation.text
      assert_equal Date.new(2021, 5, 5), affirmation.scheduled_date
    end

    test 'ordinary user cannot update an affirmation' do
      affirmation = affirmations :one

      sign_in @user
      assert_no_difference 'Affirmation.count' do
        put affirmation_path(affirmation), params: {affirmation: valid_params}
      rescue ActionController::RoutingError
        # do nothing
      end

      affirmation.reload
      assert_not_equal 'You got this!', affirmation.text
      assert_not_equal Date.new(2021, 5, 5), affirmation.scheduled_date
    end

    test 'team member can delete an affirmation' do
      affirmation = affirmations :one

      sign_in @team_member
      assert_difference 'Affirmation.count', -1 do
        delete affirmation_path(affirmation)
      end

      assert_destroyed affirmation
    end

    test 'ordinary user cannot delete an affirmation' do
      affirmation = affirmations :one

      sign_in @user
      assert_no_difference 'Affirmation.count' do
        delete affirmation_path(affirmation)
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_not_destroyed affirmation
    end
  end
end
