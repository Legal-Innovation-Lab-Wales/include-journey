FactoryBot.define do
  factory :wba_self_score do
    value { 1 }
    priority { 1 }
    wba_self { nil }
    wellbeing_metric { nil }
  end
end
