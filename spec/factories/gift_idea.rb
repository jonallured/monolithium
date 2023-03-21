FactoryBot.define do
  factory :gift_idea do
    title { "Fancy New Phone" }
    website_url { "https://www.cool-phones.com" }
    note { "More huge camera bumps!!" }

    factory :available_gift_idea do
      claimed_at { nil }
      received_at { nil }
    end

    factory :claimed_gift_idea do
      claimed_at { Time.now }
      received_at { nil }
    end

    factory :received_gift_idea do
      claimed_at { nil }
      received_at { Time.now }
    end
  end
end
