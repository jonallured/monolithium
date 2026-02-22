FactoryBot.define do
  factory :chore do
    assignee { "jon" }
    title { "Clean Up" }
    due_days { [0] }
  end
end
