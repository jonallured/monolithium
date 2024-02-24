FactoryBot.define do
  factory :financial_statement do
    financial_account
    sequence(:period_start_on) { |n| Date.today + n.months }
    starting_amount_cents { 100 }
    ending_amount_cents { 70 }
  end
end
