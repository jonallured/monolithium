FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Foo Project #{n}" }
    touched_at { Time.zone.now }
  end
end
