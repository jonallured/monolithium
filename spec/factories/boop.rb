FactoryBot.define do
  factory :boop do
    display_type { "skull" }
    number { Boop.next_number }
  end
end
