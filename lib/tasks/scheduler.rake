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

namespace :achievements do
  desc 'This task is used to create the achievement records for the current month'
  task create_monthly: :environment do
    start_date = Date.today.at_beginning_of_month
    end_date = Date.today.at_end_of_month
    count = end_date.day
    month = Date.today.strftime('%B %Y')

    Achievement.create!(
      name: "Familiar Face #{month}",
      description: 'This achievement demonstrates your commitment to using the Include Journey platform.',
      resource: 'sessions',
      starts_at: start_date,
      ends_at: end_date,
      count: count,
      intervals: { 'bronze': 5, 'silver': 15, 'gold': 25 }
    )

    Achievement.create!(
      name: "Wellbeing Warrior #{month}",
      description: 'This achievement demonstrates your commitment to tracking your wellbeing.',
      resource: 'wellbeing_assessments',
      starts_at: start_date,
      ends_at: end_date,
      count: count,
      intervals: { 'bronze': 5, 'silver': 15, 'gold': 25 }
    )

    Achievement.create!(
      name: "William Shakespeare #{month}",
      description: 'This achievement demonstrates your commitment to keeping a regular journal.',
      resource: 'journal_entries',
      starts_at: start_date,
      ends_at: end_date,
      count: count,
      intervals: { 'bronze': 5, 'silver': 15, 'gold': 25 }
    )

    Achievement.create!(
      name: "Goal Getter #{month}",
      description: 'This achievement demonstrates your commitment to reaching your goals.',
      resource: 'goals_achieved',
      starts_at: start_date,
      ends_at: end_date,
      count: count,
      intervals: { 'bronze': 5, 'silver': 15, 'gold': 25 }
    )
  end
end
