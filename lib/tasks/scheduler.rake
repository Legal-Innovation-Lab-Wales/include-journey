namespace :users do
  desc 'This task is used to delete user accounts'
  task delete: :environment do
    User.can_be_deleted.destroy_all
  end
end
