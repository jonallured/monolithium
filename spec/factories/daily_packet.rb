FactoryBot.define do
  factory :daily_packet do
    built_on { Date.parse("2007-07-07") }
    reading_list_pace { 7.7 }
    warm_fuzzy
  end
end
