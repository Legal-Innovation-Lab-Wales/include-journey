# Preview all emails at http://localhost:3000/rails/mailers/reports
class UploadsPreview < ActionMailer::Preview
  def email_team_members_about_upload
    user = User.find_by_email('ij-test-user-10@purpleriver.dev')
    upload_file = UploadFile.last
    team_members = user.team_members
    return unless team_members.present?

    upload_type = upload_file.content_type == 'application/pdf' ? 'PDF' : 'image'
    UploadsMailer.new_user_upload(team_members, user, upload_type).deliver_now
  end
end
