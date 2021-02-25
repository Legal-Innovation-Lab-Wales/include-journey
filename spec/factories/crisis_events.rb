FactoryBot.define do
  factory :crisis_event do
    additonal_info { "MyText" }
    closed { false }
    closed_by { "" }
    closed_at { "2021-02-25 21:58:00" }
    user { nil }
    crisis_type { nil }
  end
end
