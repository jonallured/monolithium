FactoryBot.define do
  factory :webhook_sender do
    name { "Circle CI" }
    parser { "CircleciParser" }
  end
end
