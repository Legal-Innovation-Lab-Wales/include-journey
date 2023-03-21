FactoryBot.define do
  factory :message do
    user { nil }
    team_member { nil }
    identifier { 1 }
    read { false }
    message_status { "MyString" }
  end
end
