# frozen_string_literal: true

class AddDeviseTwoFactorBackupableToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :otp_backup_codes, :string, array: true
  end
end
