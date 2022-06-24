FactoryBot.define do
  factory :projects_applied_tag, class: 'Projects::AppliedTag' do
    project { nil }
    tag { nil }
  end
end
