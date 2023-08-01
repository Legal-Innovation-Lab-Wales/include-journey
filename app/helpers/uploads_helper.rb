module UploadsHelper
  def correct_upload_path(model)
    if current_user
      upload_path(model)
    elsif current_team_member
      user_upload_path(@user, model)
    end
  end
end
