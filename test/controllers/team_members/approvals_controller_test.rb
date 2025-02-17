# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class ApprovalsControllerTest < ControllerTest
    test 'admin can view approve-users page' do
      sign_in @admin
      get approvals_path

      assert_response :success
    end

    test 'team member cannot view approve-users page' do
      sign_in @team_member
      get approvals_path

      assert_response :redirect
    end

    test 'admin can bulk approve users' do
      eve, fred = users :eve, :fred
      assert_not_approved eve
      assert_not_approved fred

      sign_in @admin
      post bulk_action_approvals_path, params: {user_ids: [eve.id, fred.id], status: '1'}

      assert_approved eve
      assert_approved fred
    end

    test 'team member cannot bulk approve users' do
      eve, fred = users :eve, :fred
      assert_not_approved eve
      assert_not_approved fred

      sign_in @team_member
      post bulk_action_approvals_path, params: {user_ids: [eve.id, fred.id], status: '1'}

      assert_not_approved eve
      assert_not_approved fred
    end

    test 'admin can bulk reject users' do
      eve, fred = users :eve, :fred
      assert_not_approved eve
      assert_not_approved fred

      sign_in @admin
      assert_difference 'User.count', -2 do
        post bulk_action_approvals_path, params: {user_ids: [eve.id, fred.id], status: '0'}
      end

      assert_destroyed eve
      assert_destroyed fred
    end

    test 'team member cannot bulk reject users' do
      eve, fred = users :eve, :fred
      assert_not_approved eve
      assert_not_approved fred

      sign_in @team_member
      assert_no_difference 'User.count' do
        post bulk_action_approvals_path, params: {user_ids: [eve.id, fred.id], status: '0'}
      end

      assert_not_approved eve
      assert_not_approved fred
    end

    test 'should not reject already-approved user' do
      alice = users :alice
      assert_approved alice

      sign_in @admin
      assert_no_difference 'User.count' do
        post bulk_action_approvals_path, params: {user_ids: [alice.id], status: '0'}
      end

      assert_approved alice
    end

    private

    def assert_approved(user)
      user.reload
      assert user.approved
    end

    def assert_not_approved(user)
      user.reload
      assert_not user.approved
    end
  end
end
