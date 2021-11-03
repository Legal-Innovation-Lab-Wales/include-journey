FactoryBot.define do
  factory :crisis_note do
    content { 'MyText' }
    crisis_event { nil }
    team_member { nil }
  end
end
