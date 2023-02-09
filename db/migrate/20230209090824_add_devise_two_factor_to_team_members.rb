class AddDeviseTwoFactorToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :encrypted_otp_secret, :string
    add_column :team_members, :encrypted_otp_secret_iv, :string
    add_column :team_members, :encrypted_otp_secret_salt, :string
    add_column :team_members, :consumed_timestep, :integer
    add_column :team_members, :otp_required_for_login, :boolean
  end
end
