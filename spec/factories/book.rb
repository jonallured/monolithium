FactoryBot.define do
  factory :book do
    finished_on { Time.now }
    isbn { "123" }
    pages { "100" }

    sequence(:title) { |n| "Very Cool Book, Vol. #{n}" }
  end
end
