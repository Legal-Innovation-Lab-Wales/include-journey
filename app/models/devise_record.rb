# app/models/devise_record.rb
class DeviseRecord < ApplicationRecord
  self.abstract_class = true

  def last_sign_in
    last_sign_in_at.present? ? last_sign_in_at.strftime('%d/%m/%Y %I:%M %p') : ''
  end

  def current_sign_in
    current_sign_in_at.present? ? current_sign_in_at.strftime('%d/%m/%Y %I:%M %p') : ''
  end
end
