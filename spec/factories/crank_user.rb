FactoryBot.define do
  factory :crank_user do
    sequence(:code) { |n| "abc_#{n}" }
  end
end
