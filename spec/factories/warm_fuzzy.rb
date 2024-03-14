FactoryBot.define do
  factory :warm_fuzzy do
    author { "Wife" }
    body { "Your haircut is adequate." }
    received_at { Time.now }
    title { "Alright Haircut" }
  end
end
