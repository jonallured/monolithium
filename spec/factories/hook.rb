FactoryBot.define do
  factory :hook do
    message { "" }
    raw_hook
    webhook_sender
  end
end
