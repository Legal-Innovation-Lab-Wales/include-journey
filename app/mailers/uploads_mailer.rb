# app/mailers/uploads_mailer.rb
class UploadsMailer < ApplicationMailer
  def new_user_upload(team_members, user, upload_type)
    @user = user
    @upload_type = upload_type
    @url = team_members_url
    @team_members = team_members
    mail(to: team_members.pluck(:email), subject: 'New Upload Added')
  end
end
