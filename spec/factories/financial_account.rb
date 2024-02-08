FactoryBot.define do
  factory :financial_account do
    sequence(:name) { |n| "Super Rich Account #{n}" }

    factory :usb_checking do
      name { "US Bank Checking" }
    end

    factory :wf_checking do
      name { "Wells Fargo Checking" }
    end

    factory :wf_savings do
      name { "Wells Fargo Savings" }
    end
  end
end
