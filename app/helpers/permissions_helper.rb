# app/helpers/permissions_helper.rb
module PermissionsHelper
  def last_permission(last_permissions, team_member_id)
    return true unless last_permissions.present?

    last_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
  end
end
