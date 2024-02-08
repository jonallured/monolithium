FactoryBot.define do
  factory :financial_transaction do
    financial_account
    posted_on { Date.today }
    amount_cents { 9000 }
    description { "Whole Chicken" }
  end
end
