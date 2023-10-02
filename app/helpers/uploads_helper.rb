# app/helpers/uploads_helper.rb
module UploadsHelper
  # upload show link
  def correct_upload_path(model)
    if current_user
      upload_path(model)
    elsif current_team_member
      user_upload_path(@user, model)
    end
  end

  # upload index link
  def correct_uploads_path
    if current_user
      session.key?(:custom_view) ? uploads_path(view: :list) : uploads_path
    elsif current_team_member
      session.key?(:custom_view) ? user_uploads_path(@user, view: :list) : user_uploads_path(@user)
    end
  end

  def current_user_visible_uploads
    current_user.uploads.where(visible_to_user: true)
  end

  def bytes_to_megabytes(bytes)
    (bytes.to_f / 1_048_576).round(2) # Convert bytes to MB and round to two decimal places
  end
end
