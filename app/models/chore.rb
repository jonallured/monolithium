class Chore < ApplicationRecord
  enum :assignee, {jon: 0, jess: 1, jack: 2}, validate: true

  validates :due_days, presence: true
  validates :title, presence: true
end
