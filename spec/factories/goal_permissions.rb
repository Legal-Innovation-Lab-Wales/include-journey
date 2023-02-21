FactoryBot.define do
  factory :goal_permission do
    short_term { false }
    long_term { false }
    user { nil }
    team_member { nil }
  end
end
