FactoryBot.define do
  factory :artwork do
    payload { {} }
    sequence(:gravity_id) { |n| "abc_#{n}" }
  end
end
