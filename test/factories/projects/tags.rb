FactoryBot.define do
  factory :projects_tag, class: 'Projects::Tag' do
    association :team
    name { "MyString" }
  end
end
