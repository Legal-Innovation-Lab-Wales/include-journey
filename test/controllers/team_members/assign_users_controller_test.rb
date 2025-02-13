# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class AssignUsersControllerTest < ControllerTest
    test 'team member can view assign-users page' do
      sign_in @team_member
      get team_member_users_path(@team_member)

      assert_response :success
    end

    test 'team member can assign a user to themselves' do
      barbara = team_members :barbara
      clara = users :clara
      assert_not_assigned clara, barbara

      sign_in barbara
      get team_member_user_approve_path(barbara, clara)

      assert_assigned clara, barbara
    end

    test 'team member can assign a user to another team member' do
      alan, barbara = team_members :alan, :barbara
      clara = users :clara
      assert_not_assigned clara, alan

      sign_in barbara
      get team_member_user_approve_path(alan, clara)

      assert_assigned clara, alan
    end

    test 'ordinary user cannot assign a team member to a user' do
      barbara = team_members :barbara
      clara = users :clara
      assert_not_assigned clara, barbara

      sign_in clara
      begin
        get team_member_user_approve_path(barbara, clara)
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_not_assigned clara, barbara
    end

    test 'team member can remove a user assignment from themselves' do
      barbara = team_members :barbara
      bob = users :bob
      assert_assigned bob, barbara

      sign_in barbara
      get team_member_user_approve_path(barbara, bob), params: {remove: 1}

      assert_not_assigned bob, barbara
    end

    test 'team member can remove a user assignment from another team member' do
      alan, barbara = team_members :alan, :barbara
      alice = users :alice
      assert_assigned alice, alan

      sign_in barbara
      get team_member_user_approve_path(alan, alice), params: {remove: 1}

      assert_not_assigned alice, alan
    end

    test 'ordinary user cannot remove a user assignment from a team member' do
      barbara = team_members :barbara
      bob = users :bob
      assert_assigned bob, barbara

      sign_in bob
      begin
        get team_member_user_approve_path(barbara, bob), params: {remove: 1}
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_assigned bob, barbara
    end

    test 'team member can bulk assign users to themselves' do
      barbara = team_members :barbara
      alice, clara = users :alice, :clara
      assert_not_assigned alice, barbara
      assert_not_assigned clara, barbara

      sign_in barbara
      post team_member_users_path(barbara), params: {user_ids: [alice.id, clara.id], status: '1'}

      assert_assigned alice, barbara
      assert_assigned clara, barbara
    end

    test 'team member can bulk assign users to another team member' do
      alan, barbara = team_members :alan, :barbara
      bob, clara = users :bob, :clara
      assert_not bob.assigned_team_member(alan.id)
      assert_not clara.assigned_team_member(alan.id)

      sign_in barbara
      post team_member_users_path(alan), params: {user_ids: [bob.id, clara.id], status: '1'}

      assert_assigned bob, alan
      assert_assigned clara, alan
    end

    test 'ordinary user cannot bulk assign users to a team member' do
      barbara = team_members :barbara
      alice, clara = users :alice, :clara
      assert_not_assigned alice, barbara
      assert_not_assigned clara, barbara

      sign_in clara
      begin
        post team_member_users_path(barbara), params: {user_ids: [alice.id, clara.id], status: '1'}
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_not_assigned alice, barbara
      assert_not_assigned clara, barbara
    end

    test 'team member can bulk remove user assignments from themselves' do
      barbara = team_members :barbara
      bob, david = users :bob, :david
      assert_assigned bob, barbara
      assert_assigned david, barbara

      sign_in barbara
      post team_member_users_path(barbara), params: {user_ids: [bob.id, david.id], status: '0'}

      assert_not_assigned bob, barbara
      assert_not_assigned david, barbara
    end

    test 'team member can bulk remove user assignments from another team member' do
      alan, barbara = team_members :alan, :barbara
      alice, david = users :alice, :david
      assert_assigned alice, alan
      assert_assigned david, alan

      sign_in barbara
      post team_member_users_path(alan), params: {user_ids: [alice.id, david.id], status: '0'}

      assert_not_assigned alice, alan
      assert_not_assigned david, alan
    end

    test 'ordinary user cannot bulk remove user assignments from a team member' do
      barbara = team_members :barbara
      bob, david = users :bob, :david
      assert_assigned bob, barbara
      assert_assigned david, barbara

      sign_in bob
      begin
        post team_member_users_path(barbara), params: {user_ids: [bob.id, david.id], status: '0'}
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_assigned bob, barbara
      assert_assigned david, barbara
    end

    private

    def assert_assigned(user, team_member)
      user.reload
      assert user.assigned_team_member(team_member.id)
    end

    def assert_not_assigned(user, team_member)
      user.reload
      assert_not user.assigned_team_member(team_member.id)
    end
  end
end
