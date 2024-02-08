FactoryBot.define do
  factory :financial_statement do
    financial_account
    period_start_on { Date.today }
    starting_amount_cents { 100 }
    ending_amount_cents { 70 }
  end
end
