# app/helpers/permissions_helper.rb
module PermissionsHelper
  def permission?(default, permissions, team_member_id)
    return default unless permissions.present?

    permissions.select { |team_member| team_member[:id] == team_member_id }.present?
  end
end
