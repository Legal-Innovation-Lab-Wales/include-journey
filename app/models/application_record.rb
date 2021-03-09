class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def get_created_at
    self.created_at.strftime("%d/%m/%Y %I:%M %p")
  end

  def last_update
    self.updated_at.strftime("%d/%m/%Y %I:%M %p")
  end

  def get_last_sign_in
    self.last_sign_in_at.present? ? self.last_sign_in_at.strftime("%d/%m/%Y %I:%M %p") : ''
  end

  def get_current_sign_in
    self.current_sign_in_at.present? ? self.current_sign_in_at.strftime("%d/%m/%Y %I:%M %p") : ''
  end
end
