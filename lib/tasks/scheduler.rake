namespace :users do
  desc 'This task is used to cleanup users who have decided to delete their account'
  task cleanup: :environment do
    User.where('id = ?', 1).destroy_all
  end
end
