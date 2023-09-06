class WorkDay < ApplicationRecord
  validates :date, presence: true

  def day_of_week
    date.strftime("%A")
  end
end
