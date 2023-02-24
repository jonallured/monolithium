FactoryBot.define do
  factory :project do
    name { "Foo Project" }
    touched_at { Time.zone.now }
  end
end
