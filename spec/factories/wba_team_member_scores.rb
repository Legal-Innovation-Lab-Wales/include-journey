FactoryBot.define do
  factory :wba_team_member_score do
    value { 1 }
    priority { 1 }
    wba_staff { nil }
    wellbeing_metric { nil }
  end
end
