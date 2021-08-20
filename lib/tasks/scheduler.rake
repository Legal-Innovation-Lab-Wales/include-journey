namespace :users do
  desc 'This task is used to delete user accounts'
  task delete: :environment do
    User.can_be_deleted.destroy_all
  end

  desc 'This task is used to send users email reminders'
  task send_reminder_email: :environment do
    User.not_assessed_today.each { |user| AdminMailer.reminder_email(user).deliver_now }
  end
end
