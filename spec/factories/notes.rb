FactoryBot.define do
  factory :note do
    content { "MyText" }
    visible_to_user { false }
    staff { nil }
    user { nil }
  end
end
