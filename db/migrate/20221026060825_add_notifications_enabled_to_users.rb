# frozen_string_literal: true

# db/migrate/20221026060825_add_notifications_enabled_to_users
class AddNotificationsEnabledToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notifications_enabled, :boolean, default: true
  end
end
