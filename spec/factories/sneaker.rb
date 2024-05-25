FactoryBot.define do
  factory :sneaker do
    amount_cents { 12000 }
    ordered_on { Time.now }
    sequence(:details) { |n| "Style #{n}" }
    sequence(:name) { |n| "Air Jordan #{n}" }
  end
end
