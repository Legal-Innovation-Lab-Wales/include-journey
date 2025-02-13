# frozen_string_literal: true

# app/helpers/permissions_helper.rb
module PermissionsHelper
  def has_permission(default, permissions, team_member_id)
    return default if permissions.blank?

    permissions.any? { |team_member| team_member[:id] == team_member_id }
  end
end
