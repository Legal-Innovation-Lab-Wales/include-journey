# frozen_string_literal: true

namespace :users do
  desc 'This task is used to delete user accounts'
  task delete: :environment do
    User.can_be_deleted.destroy_all
  end

  desc 'This task is used to send users email reminders'
  task send_reminder_email: :environment do
    User.not_assessed_today.each do |user|
      if user.notifications_enabled
        AdminMailer.reminder_email(user).deliver_now
      end
    end
  end
end

namespace :achievements do
  desc 'This task is used to create the achievement records for the current month'
  task create_monthly: :environment do
    start_date = Date.current.at_beginning_of_month
    end_date = Date.current.at_end_of_month
    count = end_date.day
    month = Date.current.strftime('%B %Y')

    Achievement.create!(
      name: "Familiar Face #{month}",
      description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
      entities: 'sessions',
      starts_at: start_date,
      ends_at: end_date,
      bronze_count: 10,
      silver_count: 20,
      gold_count: count,
    )

    Achievement.create!(
      name: "Wellbeing Warrior #{month}",
      description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
      entities: 'wellbeing_assessments',
      starts_at: start_date,
      ends_at: end_date,
      bronze_count: 10,
      silver_count: 20,
      gold_count: count,
    )

    Achievement.create!(
      name: "Diary Journeyman #{month}",
      description: 'This achievement demonstrates your commitment to keeping a regular diary.',
      entities: 'diary_entries',
      starts_at: start_date,
      ends_at: end_date,
      bronze_count: 10,
      silver_count: 20,
      gold_count: count,
    )

    Achievement.create!(
      name: "Goal Getter #{month}",
      description: 'This achievement demonstrates your commitment to reaching your goals.',
      entities: 'goals_achieved',
      starts_at: start_date,
      ends_at: end_date,
      bronze_count: 10,
      silver_count: 20,
      gold_count: count,
    )
  end

  desc 'This task is used to reset the users monthly counts'
  task reset_monthly_counts: :environment do
    User.skip_callback(:update, :before, :verify_achievements, raise: false)
    User.find_each(&:reset_monthly_counts)
    User.set_callback(:update, :before, :verify_achievements)
  end
end
