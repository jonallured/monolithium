class WorkDay < ApplicationRecord
  validates :date, presence: true

  def self.permitted_params
    [
      :adjust_minutes,
      :date,
      :in_minutes,
      :out_minutes,
      :pto_minutes
    ]
  end

  def day_of_week
    date.strftime("%A")
  end
end
