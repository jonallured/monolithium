FactoryBot.define do
  factory :crank_count do
    crank_user
    ticks { 7 }
    cranked_on { Date.today }
  end
end
