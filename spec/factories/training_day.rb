FactoryBot.define do
  factory :training_day do
    date { Date.today }
    intensity { "recovery" }
    with_coach { false }
  end
end
