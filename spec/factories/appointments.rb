FactoryBot.define do
  factory :appointment do
    user { nil }
    when_datetime { '' }
    who_with { 'MyString' }
    where { 'MyString' }
    what { 'MyString' }
    duration { '' }
    attended { false }
  end
end
