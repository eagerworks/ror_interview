FactoryBot.define do
  factory :invoice do
    association :team
    project { nil }
    description { "MyString" }
    total { 1 }
  end
end
